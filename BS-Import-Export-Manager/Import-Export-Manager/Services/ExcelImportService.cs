using Import_Export_Manager.Extensions;
using Import_Export_Manager.Interfaces;
using Import_Export_Manager.Models.Requests;
using Import_Export_Manager.Models.Responses;
using System.Data;
using ExcelDataReader;

namespace Import_Export_Manager.Services
{
    public class ExcelImportService : IExcelImport
    {
        private readonly ApplicationDbContext _context;
        public ExcelImportService(ApplicationDbContext context)
        {
            _context = context;
        }
        
        public async Task<ExcelImportResponse> ExcelImportXMLData(ExcelImportRequest request)
        {
            try
            {
                return await _context.ExcelImportXMLData(request);
            }
            catch (Exception ex)
            {
                return new ExcelImportResponse
                {
                    code = "1",
                    message = ex.Message,
                    data = null
                };
            }
        }

        public async Task<ExcelImportResponse> ExcelImportBulkData(ExcelImportRequest request)
        {
            try
            {
                if (request.files == null || request.files.Count == 0 || request.files[0] == null)
                {
                    return new ExcelImportResponse
                    {
                        code = "1",
                        message = "No file provided for import.",
                        data = null
                    };
                }

                DataTable excelData;
                using (var stream = request.files[0].OpenReadStream())
                {
                    excelData = ConvertExcelToDataTable(stream);
                }

                return await _context.ExcelImportBulkData(request, excelData);
            }
            catch (Exception ex)
            {
                return new ExcelImportResponse
                {
                    code = "1",
                    message = ex.Message,
                    data = null
                };
            }
        }

        private DataTable ConvertExcelToDataTable(Stream excelStream)
        {
            excelStream.Position = 0;
            System.Text.Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);

            using (var reader = ExcelReaderFactory.CreateReader(excelStream))
            {
                var config = new ExcelDataSetConfiguration
                {
                    ConfigureDataTable = _ => new ExcelDataTableConfiguration
                    {
                        UseHeaderRow = true
                    }
                };

                var dataSet = reader.AsDataSet(config);
                
                if (dataSet.Tables.Count == 0)
                {
                    throw new Exception("No worksheet found in the Excel file.");
                }

                return dataSet.Tables[0];
            }
        }
    }
}
