namespace Import_Export_Manager.Models.Data
{
    public class TImportColumnMapping
    {
        public int MappingId { get; set; }
        public int ImportId { get; set; }
        public string ExcelColumnName { get; set; }
        public string DbColumnName { get; set; }
        public string DataType { get; set; }
        public int ColumnOrder { get; set; }
        public bool IsRequired { get; set; }
        public string? DefaultValue { get; set; }
        public string? ValidationRule { get; set; }
        public bool IsActive { get; set; }
    }
}
