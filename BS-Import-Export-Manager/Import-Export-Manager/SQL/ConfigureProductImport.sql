-- =============================================
-- Sample Configuration for Product Import
-- =============================================

-- 1. Insert Import Master (if not exists)
IF NOT EXISTS (SELECT 1 FROM [imp].[t_mas_import_master] WHERE import_id = 100)
BEGIN
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
        'Product Import (Bulk)',
        'Import product data using SqlBulkCopy for high performance',
        'imp.usp_bulk_import_product',
        '/templates/product_import_template.xlsx',
        10,
        'YES',
        'Are you sure you want to import this product file? This will update existing products and create new ones.',
        'SYSTEM',
        GETDATE()
    );
    
    PRINT 'Import Master created successfully';
END
ELSE
BEGIN
    PRINT 'Import Master already exists';
END
GO

-- 2. Get the import_id
DECLARE @ImportId INT;
SELECT @ImportId = import_id FROM [imp].[t_mas_import_master] WHERE import_name = 'Product Import (Bulk)';

-- 3. Insert Column Mappings
IF NOT EXISTS (SELECT 1 FROM [imp].[t_mas_import_column_mapping] WHERE import_id = @ImportId)
BEGIN
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
    -- Product Code (Required)
    (
        @ImportId,
        '??????????',                  -- Excel column header in Thai
        'ProductCode',                  -- Database column name
        'NVARCHAR',                     -- Data type
        1,                              -- Order
        1,                              -- Required
        NULL,                           -- No default value
        'MAX_LENGTH:50',                -- Validation rule
        1                               -- Active
    ),
    -- Product Name (Required)
    (
        @ImportId,
        '??????????',
        'ProductName',
        'NVARCHAR',
        2,
        1,
        NULL,
        'MAX_LENGTH:200',
        1
    ),
    -- Price (Optional)
    (
        @ImportId,
        '????',
        'Price',
        'DECIMAL',
        3,
        0,
        '0',                            -- Default to 0 if empty
        'MIN:0;MAX:9999999',
        1
    ),
    -- Quantity (Optional)
    (
        @ImportId,
        '?????',
        'Quantity',
        'INT',
        4,
        0,
        '0',
        'MIN:0;MAX:999999',
        1
    ),
    -- Manufacture Date (Optional)
    (
        @ImportId,
        '??????????',
        'ManufactureDate',
        'DATETIME',
        5,
        0,
        NULL,
        NULL,
        1
    );

    PRINT 'Column mappings created successfully';
    PRINT 'Total columns configured: 5';
END
ELSE
BEGIN
    PRINT 'Column mappings already exist';
END
GO

-- 4. Display configuration summary
SELECT 
    im.import_id,
    im.import_name,
    im.exec_sql_command,
    COUNT(cm.mapping_id) as total_columns
FROM [imp].[t_mas_import_master] im
LEFT JOIN [imp].[t_mas_import_column_mapping] cm ON im.import_id = cm.import_id
WHERE im.import_name = 'Product Import (Bulk)'
GROUP BY im.import_id, im.import_name, im.exec_sql_command;

-- 5. Display column mapping details
SELECT 
    cm.mapping_id,
    cm.excel_column_name,
    cm.db_column_name,
    cm.data_type,
    cm.column_order,
    cm.is_required,
    cm.default_value,
    cm.validation_rule,
    cm.is_active
FROM [imp].[t_mas_import_column_mapping] cm
INNER JOIN [imp].[t_mas_import_master] im ON cm.import_id = im.import_id
WHERE im.import_name = 'Product Import (Bulk)'
ORDER BY cm.column_order;

PRINT '';
PRINT '========================================';
PRINT 'Configuration completed successfully!';
PRINT '========================================';
PRINT 'Import ID: Use the import_id from above in your API call';
PRINT 'Excel Headers: Use the excel_column_name values as column headers in your Excel file';
PRINT 'Stored Procedure: imp.usp_bulk_import_product';
PRINT 'API Endpoint: POST /api/Import/UploadExcelBulk';
GO
