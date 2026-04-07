-- =============================================
-- Bulk Import Holiday - Converted from XML to SqlBulkCopy
-- Original: tmt.usp_excel_import_holiday (XML-based)
-- New: tmt.usp_bulk_import_holiday (SqlBulkCopy-based)
-- =============================================

CREATE OR ALTER PROCEDURE [tmt].[usp_bulk_import_holiday]
    @in_vchUserId NVARCHAR(100),
    @in_vchTempTableName NVARCHAR(200),
    @out_vchErrorCode NVARCHAR(50) OUTPUT,
    @out_vchErrorMessage NVARCHAR(500) OUTPUT,
    @out_vchErrorRecord NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Create temp table for error tracking
        IF OBJECT_ID('tempdb..#TempImportResult') IS NOT NULL DROP TABLE #TempImportResult;
        CREATE TABLE #TempImportResult
        (
            ErrorCode NVARCHAR(50),
            ErrorMessage NVARCHAR(500),
            ErrorRecord NVARCHAR(100)
        );

        DECLARE @sql NVARCHAR(MAX);
        DECLARE @errorCount INT = 0;
        DECLARE @successCount INT = 0;
        DECLARE @totalRows INT = 0;

        -- Get total rows from temp table
        SET @sql = N'SELECT @count = COUNT(*) FROM ' + QUOTENAME(@in_vchTempTableName);
        EXEC sp_executesql @sql, N'@count INT OUTPUT', @count = @totalRows OUTPUT;

        -- Check if temp table has data
        IF @totalRows = 0
        BEGIN
            SET @out_vchErrorCode = '-2';
            SET @out_vchErrorMessage = 'Excel Import Error: No data found.';
            GOTO PRINT_OUTPUT;
        END

        -- ========================================
        -- 1. Data Validation
        -- ========================================
        
        -- Validate: Holiday Name cannot be empty
        SET @sql = N'
        INSERT INTO #TempImportResult (ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ''-1'' AS ErrorCode,
            ''Holiday Name cannot be empty.'' AS ErrorMessage,
            ''Row Data: '' + ISNULL(CONVERT(NVARCHAR(10), HolidayDate, 120), '''') AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE HolidayName IS NULL OR LTRIM(RTRIM(HolidayName)) = ''''
        ';
        EXEC sp_executesql @sql;

        -- Validate: Holiday Date is empty or invalid
        SET @sql = N'
        INSERT INTO #TempImportResult (ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ''-3'' AS ErrorCode,
            ''Holiday Date is empty or invalid format.'' AS ErrorMessage,
            ''Holiday Name: '' + ISNULL(HolidayName, '''') AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE HolidayDate IS NULL
        ';
        EXEC sp_executesql @sql;

        -- Validate: Duplicate Date in Excel File itself
        SET @sql = N'
        INSERT INTO #TempImportResult (ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ''-4'' AS ErrorCode,
            ''Duplicate Date found in Excel file.'' AS ErrorMessage,
            ''Date: '' + CONVERT(NVARCHAR(10), HolidayDate, 120) AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE HolidayDate IS NOT NULL
        GROUP BY HolidayDate
        HAVING COUNT(*) > 1
        ';
        EXEC sp_executesql @sql;

        -- Validate: Check if Date already exists in Database
        SET @sql = N'
        INSERT INTO #TempImportResult (ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ''-5'' AS ErrorCode,
            ''Holiday Date already exists in system.'' AS ErrorMessage,
            ''Date: '' + CONVERT(NVARCHAR(10), src.HolidayDate, 120) AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + ' src
        INNER JOIN [tmt].[t_tmt_holiday] db ON src.HolidayDate = db.holiday_date
        WHERE src.HolidayDate IS NOT NULL
        ';
        EXEC sp_executesql @sql;

        -- Check validation errors
        SELECT @errorCount = COUNT(*) FROM #TempImportResult;

        -- If validation failed, return errors
        IF @errorCount > 0
        BEGIN
            SET @out_vchErrorCode = '-1';
            SET @out_vchErrorMessage = 'Excel Import Error: Invalid data. Please see details.';
            SET @out_vchErrorRecord = CAST(@errorCount AS NVARCHAR(100));
            GOTO PRINT_OUTPUT;
        END

        -- ========================================
        -- 2. Process Data (INSERT)
        -- ?? ????? BEGIN TRANSACTION ????? C# ??????????
        -- ========================================

        -- Insert data from temp table to target table
        SET @sql = N'
        INSERT INTO [tmt].[t_tmt_holiday]
            ([holiday_date], [holiday_name], [description], [is_active], [create_by], [create_date])
        SELECT 
            HolidayDate,
            HolidayName,
            Description,
            ''YES'',
            @UserId,
            GETDATE()
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE HolidayDate IS NOT NULL AND HolidayName IS NOT NULL
        ORDER BY HolidayDate ASC
        ';
        
        EXEC sp_executesql @sql, N'@UserId NVARCHAR(100)', @UserId = @in_vchUserId;
        
        SET @successCount = @@ROWCOUNT;

        -- ========================================
        -- 3. Prepare Output
        -- ========================================
        
        SET @out_vchErrorCode = '0';
        SET @out_vchErrorMessage = 'Excel Import Success: All records imported. Processed: ' + CAST(@successCount AS NVARCHAR(10)) + ' rows out of ' + CAST(@totalRows AS NVARCHAR(10)) + ' total rows.';
        SET @out_vchErrorRecord = '0';

    END TRY
    BEGIN CATCH
        -- ?? ??? ROLLBACK ????? C# ??????????

        SET @out_vchErrorCode = CAST(ERROR_NUMBER() * -1 AS NVARCHAR(50));
        SET @out_vchErrorMessage = 'Excel Import Error: ' + ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10)) + ')';
        SET @out_vchErrorRecord = '0';

        -- Log error to process log
        BEGIN TRY
            INSERT INTO [sec].[t_com_process_log]
                ([log_type], [process], [process_datetime], [response_code], [response_message], [create_date], [create_by])
            VALUES
                ('STORE_PROCEDURE', 'usp_bulk_import_holiday', GETDATE(), @out_vchErrorCode, @out_vchErrorMessage, GETDATE(), @in_vchUserId);
        END TRY
        BEGIN CATCH
            -- Ignore logging errors
        END CATCH

        -- Insert system error
        INSERT INTO #TempImportResult(ErrorCode, ErrorMessage, ErrorRecord)
        VALUES('SYS001', ERROR_MESSAGE(), 'Line ' + CAST(ERROR_LINE() AS NVARCHAR(10)));
    END CATCH

    PRINT_OUTPUT:
    -- Return stored procedure result
    SELECT @out_vchErrorCode AS StoredErrorCode, @out_vchErrorMessage AS StoredMessage;
    
    -- Return error details (if any)
    SELECT 
        ErrorCode, 
        ErrorMessage, 
        ErrorRecord
    FROM #TempImportResult
    ORDER BY ErrorCode;

    -- ?? ??? DROP #TempImportResult ???????? C# ???????
    -- Temp table ????? cleanup ?????????????? connection ???
END
GO

-- =============================================
-- Configuration for Holiday Import
-- =============================================

-- 1. Insert or Update Import Master for Holiday
DECLARE @HolidayImportId INT;

-- Check if already exists
SELECT @HolidayImportId = import_id 
FROM [imp].[t_mas_import_master] 
WHERE import_name = 'Holiday Import (Bulk)';

IF @HolidayImportId IS NULL
BEGIN
    -- Insert new import master
    INSERT INTO [imp].[t_mas_import_master] 
    (
        import_name,
        description,
        exec_sql_command,
        excel_example_file_path,
        seq,
        is_active,
        confirm_message,
        create_by,
        create_date
    )
    VALUES
    (
        'Holiday Import (Bulk)',
        'Import holiday data using SqlBulkCopy for high performance',
        'tmt.usp_bulk_import_holiday',
        '/templates/holiday_import_template.xlsx',
        20,
        'YES',
        'Are you sure you want to import this holiday file? New holidays will be added to the system.',
        'SYSTEM',
        GETDATE()
    );

    SELECT @HolidayImportId = SCOPE_IDENTITY();
    PRINT 'Holiday Import Master created with ID: ' + CAST(@HolidayImportId AS NVARCHAR(10));
END
ELSE
BEGIN
    -- Update existing
    UPDATE [imp].[t_mas_import_master]
    SET 
        exec_sql_command = 'tmt.usp_bulk_import_holiday',
        description = 'Import holiday data using SqlBulkCopy for high performance',
        update_by = 'SYSTEM',
        update_date = GETDATE()
    WHERE import_id = @HolidayImportId;

    PRINT 'Holiday Import Master updated with ID: ' + CAST(@HolidayImportId AS NVARCHAR(10));
END

-- 2. Delete old column mappings (if any)
DELETE FROM [imp].[t_mas_import_column_mapping] WHERE import_id = @HolidayImportId;

-- 3. Insert Column Mappings for Holiday
INSERT INTO [imp].[t_mas_import_column_mapping] 
(
    import_id,
    excel_column_name,
    db_column_name,
    data_type,
    column_order,
    is_required,
    default_value,
    validation_rule,
    is_active
)
VALUES
-- Holiday Name (Required)
(
    @HolidayImportId,
    'Holiday Name',                 -- Must match Excel header exactly
    'HolidayName',                  -- Column in temp table
    'NVARCHAR',
    1,
    1,
    NULL,
    'MAX_LENGTH:100',
    1
),
-- Holiday Date (Required)
(
    @HolidayImportId,
    'Holiday Date',                 -- Must match Excel header exactly
    'HolidayDate',                  -- Column in temp table
    'DATE',
    2,
    1,
    NULL,
    NULL,
    1
),
-- Description (Optional)
(
    @HolidayImportId,
    'Description',                  -- Must match Excel header exactly
    'Description',                  -- Column in temp table
    'NVARCHAR',
    3,
    0,
    NULL,
    'MAX_LENGTH:255',
    1
);

PRINT 'Column mappings created successfully for Holiday Import';
PRINT 'Total columns configured: 3';

-- 4. Display configuration summary
SELECT 
    im.import_id,
    im.import_name,
    im.exec_sql_command,
    im.is_active,
    COUNT(cm.mapping_id) as total_columns
FROM [imp].[t_mas_import_master] im
LEFT JOIN [imp].[t_mas_import_column_mapping] cm ON im.import_id = cm.import_id
WHERE im.import_id = @HolidayImportId
GROUP BY im.import_id, im.import_name, im.exec_sql_command, im.is_active;

-- 5. Display column mapping details
SELECT 
    cm.mapping_id,
    cm.excel_column_name,
    cm.db_column_name,
    cm.data_type,
    cm.column_order,
    cm.is_required,
    cm.default_value,
    cm.is_active
FROM [imp].[t_mas_import_column_mapping] cm
WHERE cm.import_id = @HolidayImportId
ORDER BY cm.column_order;

PRINT '';
PRINT '========================================';
PRINT 'Holiday Import Configuration Completed!';
PRINT '========================================';
PRINT 'Import ID: ' + CAST(@HolidayImportId AS NVARCHAR(10));
PRINT 'Excel Headers: Holiday Name, Holiday Date, Description';
PRINT 'Stored Procedure: tmt.usp_bulk_import_holiday';
PRINT 'API Endpoint: POST /api/Import/UploadExcelBulk';
PRINT '';
PRINT 'Excel Template Format:';
PRINT '| Holiday Name | Holiday Date | Description |';
PRINT '|--------------|--------------|-------------|';
PRINT '| New Year     | 2024-01-01   | Happy New Year |';
PRINT '| Labor Day    | 2024-05-01   | International Labor Day |';
GO

-- =============================================
-- Test Script for Holiday Bulk Import
-- =============================================

/*
-- Test 1: Create test temp table
CREATE TABLE #Test_Import_Holiday
(
    HolidayName NVARCHAR(100),
    HolidayDate DATE,
    Description NVARCHAR(255)
);

-- Test 2: Insert valid test data
INSERT INTO #Test_Import_Holiday (HolidayName, HolidayDate, Description)
VALUES
    ('Test Holiday 1', '2025-12-25', 'Christmas Test'),
    ('Test Holiday 2', '2025-12-31', 'New Year Eve Test'),
    ('Test Holiday 3', '2026-01-01', 'New Year Test');

-- Test 3: Execute stored procedure
DECLARE @ErrorCode NVARCHAR(50);
DECLARE @ErrorMessage NVARCHAR(500);
DECLARE @ErrorRecord NVARCHAR(100);

EXEC [tmt].[usp_bulk_import_holiday]
    @in_vchUserId = 'TEST_USER',
    @in_vchTempTableName = '#Test_Import_Holiday',
    @out_vchErrorCode = @ErrorCode OUTPUT,
    @out_vchErrorMessage = @ErrorMessage OUTPUT,
    @out_vchErrorRecord = @ErrorRecord OUTPUT;

-- Test 4: Check results
PRINT 'Error Code: ' + ISNULL(@ErrorCode, 'NULL');
PRINT 'Error Message: ' + ISNULL(@ErrorMessage, 'NULL');
PRINT 'Error Record: ' + ISNULL(@ErrorRecord, 'NULL');

-- Test 5: Verify imported data
SELECT * FROM [tmt].[t_tmt_holiday]
WHERE create_by = 'TEST_USER'
ORDER BY holiday_date DESC;

-- Test 6: Cleanup test data
DELETE FROM [tmt].[t_tmt_holiday] WHERE create_by = 'TEST_USER';
DROP TABLE #Test_Import_Holiday;
*/

-- =============================================
-- Test with Validation Errors
-- =============================================

/*
-- Test with invalid data
CREATE TABLE #Test_Import_Holiday_Invalid
(
    HolidayName NVARCHAR(100),
    HolidayDate DATE,
    Description NVARCHAR(255)
);

INSERT INTO #Test_Import_Holiday_Invalid (HolidayName, HolidayDate, Description)
VALUES
    ('Valid Holiday', '2025-03-01', 'Valid'),
    ('', '2025-03-02', 'Empty Name - Should fail'),           -- Empty name
    ('No Date Holiday', NULL, 'No date - Should fail'),        -- NULL date
    ('Duplicate 1', '2025-03-05', 'First'),                    -- Duplicate date
    ('Duplicate 2', '2025-03-05', 'Second - Should fail');     -- Duplicate date

DECLARE @ErrorCode NVARCHAR(50);
DECLARE @ErrorMessage NVARCHAR(500);
DECLARE @ErrorRecord NVARCHAR(100);

EXEC [tmt].[usp_bulk_import_holiday]
    @in_vchUserId = 'TEST_USER',
    @in_vchTempTableName = '#Test_Import_Holiday_Invalid',
    @out_vchErrorCode = @ErrorCode OUTPUT,
    @out_vchErrorMessage = @ErrorMessage OUTPUT,
    @out_vchErrorRecord = @ErrorRecord OUTPUT;

-- Should show validation errors
PRINT 'Error Code: ' + ISNULL(@ErrorCode, 'NULL');
PRINT 'Error Message: ' + ISNULL(@ErrorMessage, 'NULL');

DROP TABLE #Test_Import_Holiday_Invalid;
*/
