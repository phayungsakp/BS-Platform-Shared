-- =============================================
-- SQL Scripts for Bulk Import Enhancement
-- =============================================

-- 1. Create Column Mapping Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 't_mas_import_column_mapping' AND schema_id = SCHEMA_ID('imp'))
BEGIN
    CREATE TABLE [imp].[t_mas_import_column_mapping]
    (
        [mapping_id] INT IDENTITY(1,1) PRIMARY KEY,
        [import_id] INT NOT NULL,
        [excel_column_name] NVARCHAR(100) NOT NULL,
        [db_column_name] NVARCHAR(100) NOT NULL,
        [data_type] NVARCHAR(50) NOT NULL DEFAULT 'NVARCHAR',
        [column_order] INT NOT NULL,
        [is_required] BIT NOT NULL DEFAULT 0,
        [default_value] NVARCHAR(200) NULL,
        [validation_rule] NVARCHAR(500) NULL,
        [is_active] BIT NOT NULL DEFAULT 1,
        CONSTRAINT FK_ImportColumnMapping_ImportMaster 
            FOREIGN KEY ([import_id]) REFERENCES [imp].[t_mas_import_master]([import_id])
    );
    
    CREATE INDEX IX_ImportColumnMapping_ImportId ON [imp].[t_mas_import_column_mapping]([import_id]);
END
GO

-- 2. Example Stored Procedure Template for Bulk Import
-- Note: You need to modify this based on your actual business logic
CREATE OR ALTER PROCEDURE [imp].[usp_bulk_import_example]
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
            ErrorCode NVARCHAR(50),
            ErrorMessage NVARCHAR(500),
            ErrorRecord NVARCHAR(100)
        );

        DECLARE @sql NVARCHAR(MAX);
        DECLARE @errorCount INT = 0;

        -- Example: Validate data from temp table
        SET @sql = N'
        INSERT INTO #TempImportResult (ErrorCode, ErrorMessage, ErrorRecord)
        SELECT 
            ''VAL001'' AS ErrorCode,
            ''Validation Error: '' + COALESCE(ErrorReason, ''Unknown'') AS ErrorMessage,
            CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR(100)) AS ErrorRecord
        FROM ' + QUOTENAME(@in_vchTempTableName) + '
        WHERE 1=0 -- Add your validation logic here
        ';
        
        EXEC sp_executesql @sql;

        -- Example: Insert/Update your actual table from temp table
        SET @sql = N'
        MERGE INTO [dbo].[YourTargetTable] AS Target
        USING ' + QUOTENAME(@in_vchTempTableName) + ' AS Source
        ON Target.YourKeyColumn = Source.YourKeyColumn
        WHEN MATCHED THEN
            UPDATE SET
                Target.Column1 = Source.Column1,
                Target.Column2 = Source.Column2,
                Target.UpdateBy = @UserId,
                Target.UpdateDate = GETDATE()
        WHEN NOT MATCHED THEN
            INSERT (Column1, Column2, CreateBy, CreateDate)
            VALUES (Source.Column1, Source.Column2, @UserId, GETDATE());
        ';
        
        EXEC sp_executesql @sql, N'@UserId NVARCHAR(40)', @UserId = @in_vchUserId;

        -- Get error count
        SELECT @errorCount = COUNT(*) FROM #TempImportResult;

        IF @errorCount > 0
        BEGIN
            SET @out_vchErrorCode = '1';
            SET @out_vchErrorMessage = 'Import completed with ' + CAST(@errorCount AS NVARCHAR(10)) + ' error(s)';
        END
        ELSE
        BEGIN
            SET @out_vchErrorCode = '0';
            SET @out_vchErrorMessage = 'Import completed successfully';
        END

        SET @out_vchErrorRecord = CAST(@errorCount AS NVARCHAR(100));

        -- Return error details
        SELECT ErrorCode, ErrorMessage, ErrorRecord
        FROM #TempImportResult;

    END TRY
    BEGIN CATCH
        SET @out_vchErrorCode = '1';
        SET @out_vchErrorMessage = ERROR_MESSAGE();
        SET @out_vchErrorRecord = '0';
        
        -- Return error
        SELECT 
            '1' AS ErrorCode,
            ERROR_MESSAGE() AS ErrorMessage,
            '0' AS ErrorRecord;
    END CATCH
END
GO

-- 3. Example: Insert sample column mapping configuration
-- Note: Adjust these mappings based on your actual import requirements
/*
INSERT INTO [imp].[t_mas_import_column_mapping] 
    ([import_id], [excel_column_name], [db_column_name], [data_type], [column_order], [is_required], [is_active])
VALUES
    (1, 'Column1', 'Column1', 'NVARCHAR', 1, 1, 1),
    (1, 'Column2', 'Column2', 'NVARCHAR', 2, 0, 1),
    (1, 'Column3', 'Column3', 'INT', 3, 1, 1),
    (1, 'Column4', 'Column4', 'DECIMAL', 4, 0, 1),
    (1, 'Column5', 'Column5', 'DATETIME', 5, 0, 1);
*/

-- 4. Update existing import master to use new bulk import stored procedure
/*
UPDATE [imp].[t_mas_import_master]
SET [exec_sql_command] = 'imp.usp_bulk_import_example'
WHERE [import_id] = 1;
*/

PRINT 'Bulk Import Enhancement Scripts Completed Successfully';
GO
