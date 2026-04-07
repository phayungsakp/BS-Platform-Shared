-- =============================================
-- Example: Complete Bulk Import Stored Procedure
-- ?????? Import ???????????? (Product)
-- =============================================

CREATE OR ALTER PROCEDURE [imp].[usp_bulk_import_product]
    @in_vchUserId NVARCHAR(40),
    @in_vchTempTableName NVARCHAR(200),
    @out_vchErrorCode NVARCHAR(50) OUTPUT,
    @out_vchErrorMessage NVARCHAR(500) OUTPUT,
    @out_vchErrorRecord NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Create temp table for error tracking
        CREATE TABLE #TempImportResult
        (
            RowNumber INT,
            ErrorCode NVARCHAR(50),
            ErrorMessage NVARCHAR(500),
            ErrorRecord NVARCHAR(100)
        );

        DECLARE @sql NVARCHAR(MAX);
        DECLARE @errorCount INT = 0;
        DECLARE @successCount INT = 0;
        DECLARE @totalRows INT = 0;

        -- Get total rows
        SET @sql = N'SELECT @count = COUNT(*) FROM ' + QUOTENAME(@in_vchTempTableName);
        EXEC sp_executesql @sql, N'@count INT OUTPUT', @count = @totalRows OUTPUT;

        -- ========================================
        -- 1. Data Validation
        -- ========================================
        
        -- Validate: Required fields
        SET @sql = N'
        INSERT INTO #TempImportResult (RowNumber, ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as RowNum,
            ''REQ001'' AS ErrorCode,
            ''Required field is missing: ProductCode'' AS ErrorMessage,
            ''Row '' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR(50)) AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE ProductCode IS NULL OR LTRIM(RTRIM(ProductCode)) = ''''
        ';
        EXEC sp_executesql @sql;

        SET @sql = N'
        INSERT INTO #TempImportResult (RowNumber, ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as RowNum,
            ''REQ002'' AS ErrorCode,
            ''Required field is missing: ProductName'' AS ErrorMessage,
            ''Row '' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR(50)) AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE ProductName IS NULL OR LTRIM(RTRIM(ProductName)) = ''''
        ';
        EXEC sp_executesql @sql;

        -- Validate: Duplicate ProductCode in file
        SET @sql = N'
        INSERT INTO #TempImportResult (RowNumber, ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ROW_NUMBER() OVER(ORDER BY ProductCode) as RowNum,
            ''DUP001'' AS ErrorCode,
            ''Duplicate ProductCode in file: '' + ProductCode AS ErrorMessage,
            ''ProductCode: '' + ProductCode AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        GROUP BY ProductCode
        HAVING COUNT(*) > 1
        ';
        EXEC sp_executesql @sql;

        -- Validate: Price must be greater than 0
        SET @sql = N'
        INSERT INTO #TempImportResult (RowNumber, ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as RowNum,
            ''VAL001'' AS ErrorCode,
            ''Price must be greater than 0 for ProductCode: '' + ProductCode AS ErrorMessage,
            ''Row '' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR(50)) AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE Price IS NOT NULL AND Price <= 0
        ';
        EXEC sp_executesql @sql;

        -- Validate: Quantity must be >= 0
        SET @sql = N'
        INSERT INTO #TempImportResult (RowNumber, ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as RowNum,
            ''VAL002'' AS ErrorCode,
            ''Quantity must be greater than or equal to 0 for ProductCode: '' + ProductCode AS ErrorMessage,
            ''Row '' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR(50)) AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE Quantity IS NOT NULL AND Quantity < 0
        ';
        EXEC sp_executesql @sql;

        -- Check validation errors
        SELECT @errorCount = COUNT(*) FROM #TempImportResult;

        -- ========================================
        -- 2. Process Data (MERGE)
        -- ========================================
        
        IF @errorCount = 0
        BEGIN
            -- Create table if not exists (example)
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 't_product' AND schema_id = SCHEMA_ID('dbo'))
            BEGIN
                CREATE TABLE [dbo].[t_product]
                (
                    [product_id] INT IDENTITY(1,1) PRIMARY KEY,
                    [product_code] NVARCHAR(50) NOT NULL UNIQUE,
                    [product_name] NVARCHAR(200) NOT NULL,
                    [price] DECIMAL(18,2) NULL,
                    [quantity] INT NULL,
                    [manufacture_date] DATETIME NULL,
                    [is_active] BIT NOT NULL DEFAULT 1,
                    [create_by] NVARCHAR(40) NOT NULL,
                    [create_date] DATETIME NOT NULL DEFAULT GETDATE(),
                    [update_by] NVARCHAR(40) NULL,
                    [update_date] DATETIME NULL
                );
            END

            -- MERGE data from temp table to target table
            SET @sql = N'
            MERGE INTO [dbo].[t_product] AS Target
            USING ' + QUOTENAME(@in_vchTempTableName) + ' AS Source
            ON Target.product_code = Source.ProductCode
            WHEN MATCHED THEN
                UPDATE SET
                    Target.product_name = Source.ProductName,
                    Target.price = Source.Price,
                    Target.quantity = Source.Quantity,
                    Target.manufacture_date = Source.ManufactureDate,
                    Target.update_by = @UserId,
                    Target.update_date = GETDATE()
            WHEN NOT MATCHED THEN
                INSERT (
                    product_code, 
                    product_name, 
                    price, 
                    quantity, 
                    manufacture_date,
                    create_by, 
                    create_date
                )
                VALUES (
                    Source.ProductCode,
                    Source.ProductName,
                    Source.Price,
                    Source.Quantity,
                    Source.ManufactureDate,
                    @UserId,
                    GETDATE()
                );
            ';
            
            EXEC sp_executesql @sql, N'@UserId NVARCHAR(40)', @UserId = @in_vchUserId;
            
            SET @successCount = @@ROWCOUNT;
        END

        -- ========================================
        -- 3. Prepare Output
        -- ========================================
        
        IF @errorCount > 0
        BEGIN
            SET @out_vchErrorCode = '1';
            SET @out_vchErrorMessage = 'Import validation failed with ' + CAST(@errorCount AS NVARCHAR(10)) + ' error(s). Total rows: ' + CAST(@totalRows AS NVARCHAR(10));
        END
        ELSE
        BEGIN
            SET @out_vchErrorCode = '0';
            SET @out_vchErrorMessage = 'Import completed successfully. Processed: ' + CAST(@successCount AS NVARCHAR(10)) + ' rows out of ' + CAST(@totalRows AS NVARCHAR(10)) + ' total rows';
        END

        SET @out_vchErrorRecord = CAST(@errorCount AS NVARCHAR(100));

        -- Return error details (if any)
        SELECT 
            ErrorCode, 
            ErrorMessage, 
            ErrorRecord
        FROM #TempImportResult
        ORDER BY RowNumber;

    END TRY
    BEGIN CATCH
        SET @out_vchErrorCode = '1';
        SET @out_vchErrorMessage = 'Error: ' + ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10)) + ')';
        SET @out_vchErrorRecord = '0';
        
        -- Return error
        SELECT 
            'SYS001' AS ErrorCode,
            ERROR_MESSAGE() AS ErrorMessage,
            'Line ' + CAST(ERROR_LINE() AS NVARCHAR(10)) AS ErrorRecord;
    END CATCH
END
GO

-- =============================================
-- Test the stored procedure
-- =============================================

/*
-- 1. Create test temp table
CREATE TABLE #Test_Import_Product
(
    ProductCode NVARCHAR(50),
    ProductName NVARCHAR(200),
    Price DECIMAL(18,2),
    Quantity INT,
    ManufactureDate DATETIME
);

-- 2. Insert test data
INSERT INTO #Test_Import_Product (ProductCode, ProductName, Price, Quantity, ManufactureDate)
VALUES
    ('P001', 'Product 1', 100.00, 10, '2024-01-01'),
    ('P002', 'Product 2', 200.00, 20, '2024-01-02'),
    ('P003', 'Product 3', 300.00, 30, '2024-01-03'),
    ('P004', 'Product 4', -50.00, 40, '2024-01-04'), -- Invalid: negative price
    ('P005', '', 500.00, 50, '2024-01-05'); -- Invalid: empty name

-- 3. Execute stored procedure
DECLARE @ErrorCode NVARCHAR(50);
DECLARE @ErrorMessage NVARCHAR(500);
DECLARE @ErrorRecord NVARCHAR(100);

EXEC [imp].[usp_bulk_import_product]
    @in_vchUserId = 'TEST_USER',
    @in_vchTempTableName = '#Test_Import_Product',
    @out_vchErrorCode = @ErrorCode OUTPUT,
    @out_vchErrorMessage = @ErrorMessage OUTPUT,
    @out_vchErrorRecord = @ErrorRecord OUTPUT;

-- 4. Check results
PRINT 'Error Code: ' + ISNULL(@ErrorCode, 'NULL');
PRINT 'Error Message: ' + ISNULL(@ErrorMessage, 'NULL');
PRINT 'Error Record: ' + ISNULL(@ErrorRecord, 'NULL');

-- 5. Check imported data
SELECT * FROM [dbo].[t_product];
*/
