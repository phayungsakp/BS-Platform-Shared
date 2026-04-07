using Azure.Core;
using DocumentFormat.OpenXml.InkML;
using Import_Export_Manager.Models.Data;
using Import_Export_Manager.Models.Requests;
using Import_Export_Manager.Models.Responses;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace Import_Export_Manager.Extensions
{
    public class ApplicationDbContext : IdentityDbContext<IdentityUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
        public virtual DbSet<TImportMaster> TImportMasters { get; set; }
        public virtual DbSet<TImportColumnMapping> TImportColumnMappings { get; set; }
        
        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.UseCollation("Thai_CI_AS");
            builder.Entity<TImportMaster>(entity =>
            {
                entity.ToTable("t_mas_import_master", "imp");
                entity.HasKey(e => e.ImportId);
                entity.Property(e => e.ImportId).HasColumnName("import_id");
                entity.Property(e => e.ImportName).HasColumnName("import_name").HasMaxLength(200).IsRequired();
                entity.Property(e => e.Description).HasColumnName("description").HasMaxLength(200);
                entity.Property(e => e.ExecSqlCommand).HasColumnName("exec_sql_command").HasColumnType("NVARCHAR(MAX)");
                entity.Property(e => e.ExcelExampleFilePath).HasColumnName("excel_example_file_path").HasMaxLength(500);
                entity.Property(e => e.Seq).HasColumnName("seq").IsRequired();
                entity.Property(e => e.IsActive).HasColumnName("is_active").HasMaxLength(3).IsRequired().HasDefaultValue("YES");
                entity.Property(e => e.ConfirmMessage).HasColumnName("confirm_message").HasColumnType("NVARCHAR(MAX)");
                entity.Property(e => e.CreateBy).HasColumnName("create_by").IsRequired().HasMaxLength(40);
                entity.Property(e => e.CreatedDate).HasColumnName("create_date").IsRequired();
                entity.Property(e => e.UpdateBy).HasColumnName("update_by").HasMaxLength(40);
                entity.Property(e => e.UpdateDate).HasColumnName("update_date");
            });

            builder.Entity<TImportColumnMapping>(entity =>
            {
                entity.ToTable("t_mas_import_column_mapping", "imp");
                entity.HasKey(e => e.MappingId);
                entity.Property(e => e.MappingId).HasColumnName("mapping_id");
                entity.Property(e => e.ImportId).HasColumnName("import_id").IsRequired();
                entity.Property(e => e.ExcelColumnName).HasColumnName("excel_column_name").HasMaxLength(100).IsRequired();
                entity.Property(e => e.DbColumnName).HasColumnName("db_column_name").HasMaxLength(100).IsRequired();
                entity.Property(e => e.DataType).HasColumnName("data_type").HasMaxLength(50).IsRequired();
                entity.Property(e => e.ColumnOrder).HasColumnName("column_order").IsRequired();
                entity.Property(e => e.IsRequired).HasColumnName("is_required").IsRequired();
                entity.Property(e => e.DefaultValue).HasColumnName("default_value").HasMaxLength(200);
                entity.Property(e => e.ValidationRule).HasColumnName("validation_rule").HasMaxLength(500);
                entity.Property(e => e.IsActive).HasColumnName("is_active").IsRequired().HasDefaultValue(true);
            });

            base.OnModelCreating(builder);
        }
        
        public async Task<ImportMasterResponse> InsertImportMaster(ImportMasterRequest request)
        {
            var errorCodeParam = new SqlParameter("@out_vchErrorCode", SqlDbType.NVarChar, 10)
            {
                Direction = ParameterDirection.Output
            };
            var errorMessageParam = new SqlParameter("@out_vchErrorMessage", SqlDbType.NVarChar, 200)
            {
                Direction = ParameterDirection.Output
            };
            var in_vchImportName = new SqlParameter("@in_vchImportName", SqlDbType.NVarChar, 200)
            {
                Direction = ParameterDirection.Input,
                Value = request.import_name
            };
            var in_vchDescription = new SqlParameter("@in_vchDescription", SqlDbType.NVarChar, 200)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.description ?? DBNull.Value
            };
            var in_vchExecSqlCommand = new SqlParameter("@in_vchExecSqlCommand", SqlDbType.NVarChar, -1)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.exec_sql_command ?? DBNull.Value
            };
            var in_vchExcelExampleFilePath = new SqlParameter("@in_vchExcelExampleFilePath", SqlDbType.NVarChar, 500)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.excel_example_file_path ?? DBNull.Value
            };
            var in_intSeq = new SqlParameter("@in_intSeq", SqlDbType.Int)
            {
                Direction = ParameterDirection.Input,
                Value = request.seq
            };
            var in_vchIsActive = new SqlParameter("@in_vchIsActive", SqlDbType.NVarChar, 3)
            {
                Direction = ParameterDirection.Input,
                Value = request.is_active
            };
            var in_vchConfirmMessage = new SqlParameter("@in_vchConfirmMessage", SqlDbType.NVarChar, -1)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.confirm_message ?? DBNull.Value
            };
            var in_vchCreateBy = new SqlParameter("@in_vchCreateBy", SqlDbType.NVarChar, 40)
            {
                Direction = ParameterDirection.Input,
                Value = request.create_by
            };
            await Database.ExecuteSqlRawAsync(
                $"EXEC imp.usp_insert_import_master " +
                $"@in_vchImportName, @in_vchDescription, @in_vchExecSqlCommand, @in_vchExcelExampleFilePath, @in_intSeq, @in_vchIsActive, @in_vchConfirmMessage, @in_vchCreateBy, @out_vchErrorCode OUTPUT, @out_vchErrorMessage OUTPUT",
                in_vchImportName, in_vchDescription, in_vchExecSqlCommand, in_vchExcelExampleFilePath, in_intSeq, in_vchIsActive, in_vchConfirmMessage, in_vchCreateBy, errorCodeParam, errorMessageParam);
            return new ImportMasterResponse
            {
                code = errorCodeParam.Value?.ToString(),
                message = errorMessageParam.Value?.ToString(),
                data = null,
                total = 0
            };
        }
        public async Task<ImportMasterResponse> UpdateImportMaster(int importId, ImportMasterRequest request)
        {
            var errorCodeParam = new SqlParameter("@out_vchErrorCode", SqlDbType.NVarChar, 10)
            {
                Direction = ParameterDirection.Output
            };
            var errorMessageParam = new SqlParameter("@out_vchErrorMessage", SqlDbType.NVarChar, 200)
            {
                Direction = ParameterDirection.Output
            };
            var in_intImportId = new SqlParameter("@in_intImportId", SqlDbType.Int)
            {
                Direction = ParameterDirection.Input,
                Value = importId
            };
            var in_vchImportName = new SqlParameter("@in_vchImportName", SqlDbType.NVarChar, 200)
            {
                Direction = ParameterDirection.Input,
                Value = request.import_name
            };
            var in_vchDescription = new SqlParameter("@in_vchDescription", SqlDbType.NVarChar, 200)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.description ?? DBNull.Value
            };
            var in_vchExecSqlCommand = new SqlParameter("@in_vchExecSqlCommand", SqlDbType.NVarChar, -1)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.exec_sql_command ?? DBNull.Value
            };
            var in_vchExcelExampleFilePath = new SqlParameter("@in_vchExcelExampleFilePath", SqlDbType.NVarChar, 500)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.excel_example_file_path ?? DBNull.Value
            };
            var in_intSeq = new SqlParameter("@in_intSeq", SqlDbType.Int)
            {
                Direction = ParameterDirection.Input,
                Value = request.seq
            };
            var in_vchIsActive = new SqlParameter("@in_vchIsActive", SqlDbType.NVarChar, 3)
            {
                Direction = ParameterDirection.Input,
                Value = request.is_active
            };
            var in_vchConfirmMessage = new SqlParameter("@in_vchConfirmMessage", SqlDbType.NVarChar, -1)
            {
                Direction = ParameterDirection.Input,
                Value = (object?)request.confirm_message ?? DBNull.Value
            };
            var in_vchUpdateBy = new SqlParameter("@in_vchUpdateBy", SqlDbType.NVarChar, 40)
            {
                Direction = ParameterDirection.Input,
                Value = request.update_by
            };
            await Database.ExecuteSqlRawAsync(
                $"EXEC imp.usp_update_import_master " +
                $"@in_intImportId, @in_vchImportName, @in_vchDescription, @in_vchExecSqlCommand, @in_vchExcelExampleFilePath, @in_intSeq, @in_vchIsActive, @in_vchConfirmMessage, @in_vchUpdateBy, @out_vchErrorCode OUTPUT, @out_vchErrorMessage OUTPUT",
                in_intImportId, in_vchImportName, in_vchDescription, in_vchExecSqlCommand, in_vchExcelExampleFilePath, in_intSeq, in_vchIsActive, in_vchConfirmMessage, in_vchUpdateBy, errorCodeParam, errorMessageParam);

            return new ImportMasterResponse
            {
                code = errorCodeParam.Value?.ToString(),
                message = errorMessageParam.Value?.ToString(),
                data = null,
                total = 0
            };
        }
        public async Task<ImportMasterResponse> DeleteImportMaster(int importId)
        {
            var errorCodeParam = new SqlParameter("@out_vchErrorCode", SqlDbType.NVarChar, 10)
            {
                Direction = ParameterDirection.Output
            };
            var errorMessageParam = new SqlParameter("@out_vchErrorMessage", SqlDbType.NVarChar, 200)
            {
                Direction = ParameterDirection.Output
            };
            var in_intImportId = new SqlParameter("@in_intImportId", SqlDbType.Int)
            {
                Direction = ParameterDirection.Input,
                Value = importId
            };
            await Database.ExecuteSqlRawAsync(
                $"EXEC imp.usp_delete_import_master " +
                $"@in_intImportId, @out_vchErrorCode OUTPUT, @out_vchErrorMessage OUTPUT",
                in_intImportId, errorCodeParam, errorMessageParam);
            return new ImportMasterResponse
            {
                code = errorCodeParam.Value?.ToString(),
                message = errorMessageParam.Value?.ToString(),
                data = null,
                total = 0
            };
        }
        public async Task<List<ImportMasterListResponse>> GetAllImportMasters()
        {
            var importMasters = await TImportMasters
                .AsNoTracking()
                .OrderBy(im => im.Seq)
                .ToListAsync();
            return importMasters.Select(im => new ImportMasterListResponse
            {
                import_id = im.ImportId,
                import_name = im.ImportName,
                description = im.Description,
                exec_sql_command = im.ExecSqlCommand,
                excel_example_file_path = im.ExcelExampleFilePath,
                seq = im.Seq,
                is_active = im.IsActive,
                confirm_message = im.ConfirmMessage,
                create_by = im.CreateBy,
                created_date = im.CreatedDate,
                update_by = im.UpdateBy,
                update_date = im.UpdateDate
            }).ToList();
        }
        public async Task<ExcelImportResponse> ExcelImportXMLData(ExcelImportRequest request)
        {
            try
            {
                var entity = await this.TImportMasters
                    .FirstOrDefaultAsync(x => x.ImportId == request.import_id);

                if (entity == null)
                {
                    return new ExcelImportResponse
                    {
                        code = "1",
                        message = "Import configuration not found.",
                        data = null
                    };
                }

                var execSqlCommand = entity?.ExecSqlCommand;
                if (string.IsNullOrEmpty(execSqlCommand))
                {
                    return new ExcelImportResponse
                    {
                        code = "1",
                        message = "Import configuration not found.",
                        data = null
                    };
                }

                var errorCodeParam = new SqlParameter("@out_vchErrorCode", SqlDbType.NVarChar, 50)
                {
                    Direction = ParameterDirection.Output
                };
                var errorMessageParam = new SqlParameter("@out_vchErrorMessage", SqlDbType.NVarChar, 500)
                {
                    Direction = ParameterDirection.Output
                };
                var errorRecordParam = new SqlParameter("@out_vchErrorRecord", SqlDbType.NVarChar, 100)
                {
                    Direction = ParameterDirection.Output
                };
                var in_vchUserId = new SqlParameter("@in_vchUserId", SqlDbType.NVarChar, 40)
                {
                    Direction = ParameterDirection.Input,
                    Value = request.user_id
                };
                var in_XMLData = new SqlParameter("@in_XMLData", SqlDbType.NVarChar, -1)
                {
                    Direction = ParameterDirection.Input,
                    Value = (object?)request.xml_import_data ?? DBNull.Value
                };

                var errors = new List<ExcelImportListResponse>();


                using (var conn = Database.GetDbConnection())
                {
                    await conn.OpenAsync();

                    using (var command = conn.CreateCommand())
                    {
                        command.CommandText = execSqlCommand;
                        command.CommandType = System.Data.CommandType.StoredProcedure;

                        command.Parameters.Add(in_vchUserId);
                        command.Parameters.Add(in_XMLData);
                        command.Parameters.Add(errorCodeParam);
                        command.Parameters.Add(errorMessageParam);
                        command.Parameters.Add(errorRecordParam);

                        using (var reader = await command.ExecuteReaderAsync())
                        {
                            // Result set แรก (ถ้ามี) ข้ามได้
                            if (await reader.ReadAsync()) { }

                            // Result set ที่สอง: #TempImportResult
                            if (await reader.NextResultAsync())
                            {
                                while (await reader.ReadAsync())
                                {
                                    errors.Add(new ExcelImportListResponse
                                    {
                                        code = reader["ErrorCode"]?.ToString(),
                                        message = reader["ErrorMessage"]?.ToString(),
                                        records = reader["ErrorRecord"]?.ToString()
                                    });
                                }
                            }
                        }
                    }
                }

                return new ExcelImportResponse
                {
                    code = errorCodeParam.Value?.ToString() ?? "0",
                    message = errorMessageParam.Value?.ToString() ?? "Import completed",
                    data = errors,
                    total = errors.Count
                };
            }
            catch (Exception ex)
            {
                return new ExcelImportResponse
                {
                    code = "1",
                    message = ex.Message,
                    data = null,
                    total = 0
                };
            }
        }

        public async Task<ExcelImportResponse> ExcelImportBulkData(ExcelImportRequest request, DataTable excelData)
        {
            try
            {
                var entity = await this.TImportMasters
                    .FirstOrDefaultAsync(x => x.ImportId == request.import_id);

                if (entity == null)
                {
                    return new ExcelImportResponse
                    {
                        code = "1",
                        message = "Import configuration not found.",
                        data = null
                    };
                }

                var execSqlCommand = entity?.ExecSqlCommand;
                if (string.IsNullOrEmpty(execSqlCommand))
                {
                    return new ExcelImportResponse
                    {
                        code = "1",
                        message = "Stored procedure not configured.",
                        data = null
                    };
                }

                var columnMappings = await TImportColumnMappings
                    .Where(x => x.ImportId == request.import_id && x.IsActive)
                    .OrderBy(x => x.ColumnOrder)
                    .ToListAsync();

                if (!columnMappings.Any())
                {
                    return new ExcelImportResponse
                    {
                        code = "1",
                        message = "Column mapping configuration not found.",
                        data = null
                    };
                }

                var tempTableName = $"#Tmp_Import_Data_{Guid.NewGuid():N}";
                var errors = new List<ExcelImportListResponse>();

                using (var connection = new SqlConnection(Database.GetConnectionString()))
                {
                    await connection.OpenAsync();
                    using (var transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            var mappedDataTable = MapExcelToDbColumns(excelData, columnMappings);
                            
                            await CreateTempTableAsync(connection, transaction, tempTableName, columnMappings);

                            using (var bulkCopy = new SqlBulkCopy(connection, SqlBulkCopyOptions.Default, transaction))
                            {
                                bulkCopy.DestinationTableName = tempTableName;
                                bulkCopy.BatchSize = request.batch_size.HasValue && request.batch_size.Value > 0 ? request.batch_size.Value : 5000;
                                bulkCopy.BulkCopyTimeout = 600;

                                foreach (var mapping in columnMappings)
                                {
                                    bulkCopy.ColumnMappings.Add(mapping.DbColumnName, mapping.DbColumnName);
                                }

                                await bulkCopy.WriteToServerAsync(mappedDataTable);
                            }

                            using (var command = connection.CreateCommand())
                            {
                                command.Transaction = transaction;
                                command.CommandText = execSqlCommand;
                                command.CommandType = CommandType.StoredProcedure;
                                command.CommandTimeout = 600;

                                var in_vchUserId = new SqlParameter("@in_vchUserId", SqlDbType.NVarChar, 40)
                                {
                                    Direction = ParameterDirection.Input,
                                    Value = request.user_id
                                };
                                var in_vchTempTableName = new SqlParameter("@in_vchTempTableName", SqlDbType.NVarChar, 200)
                                {
                                    Direction = ParameterDirection.Input,
                                    Value = tempTableName
                                };
                                var errorCodeParam = new SqlParameter("@out_vchErrorCode", SqlDbType.NVarChar, 50)
                                {
                                    Direction = ParameterDirection.Output
                                };
                                var errorMessageParam = new SqlParameter("@out_vchErrorMessage", SqlDbType.NVarChar, 500)
                                {
                                    Direction = ParameterDirection.Output
                                };
                                var errorRecordParam = new SqlParameter("@out_vchErrorRecord", SqlDbType.NVarChar, 100)
                                {
                                    Direction = ParameterDirection.Output
                                };

                                command.Parameters.Add(in_vchUserId);
                                command.Parameters.Add(in_vchTempTableName);
                                command.Parameters.Add(errorCodeParam);
                                command.Parameters.Add(errorMessageParam);
                                command.Parameters.Add(errorRecordParam);

                                using (var reader = await command.ExecuteReaderAsync())
                                {
                                    // Read first result set (stored procedure output)
                                    if (await reader.ReadAsync())
                                    {
                                        // Optionally read StoredErrorCode and StoredMessage if needed
                                    }

                                    // Read second result set (error details from #TempImportResult)
                                    if (await reader.NextResultAsync())
                                    {
                                        while (await reader.ReadAsync())
                                        {
                                            errors.Add(new ExcelImportListResponse
                                            {
                                                code = reader["ErrorCode"]?.ToString(),
                                                message = reader["ErrorMessage"]?.ToString(),
                                                records = reader["ErrorRecord"]?.ToString()
                                            });
                                        }
                                    }
                                }

                                // Get result code from output parameter
                                var resultCode = errorCodeParam.Value?.ToString() ?? "0";
                                
                                // Commit or rollback based on stored procedure result
                                if (resultCode == "0")
                                {
                                    await transaction.CommitAsync();
                                }
                                else
                                {
                                    await transaction.RollbackAsync();
                                }

                                return new ExcelImportResponse
                                {
                                    code = resultCode,
                                    message = errorMessageParam.Value?.ToString() ?? "Import completed",
                                    data = errors,
                                    total = errors.Count
                                };
                            }
                        }
                        catch (Exception ex)
                        {
                            await transaction.RollbackAsync();
                            
                            return new ExcelImportResponse
                            {
                                code = "1",
                                message = $"Import failed: {ex.Message}",
                                data = new List<ExcelImportListResponse>
                                {
                                    new ExcelImportListResponse
                                    {
                                        code = "SYS001",
                                        message = ex.Message,
                                        records = ex.StackTrace?.Split('\n').FirstOrDefault() ?? ""
                                    }
                                },
                                total = 1
                            };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new ExcelImportResponse
                {
                    code = "1",
                    message = ex.Message,
                    data = null,
                    total = 0
                };
            }
        }

        private DataTable MapExcelToDbColumns(DataTable excelData, List<TImportColumnMapping> columnMappings)
        {
            var mappedTable = new DataTable();

            foreach (var mapping in columnMappings)
            {
                var dataType = mapping.DataType.ToLowerInvariant() switch
                {
                    "int" or "integer" => typeof(int),
                    "bigint" or "long" => typeof(long),
                    "decimal" or "numeric" or "money" => typeof(decimal),
                    "float" or "real" => typeof(double),
                    "bit" or "boolean" => typeof(bool),
                    "datetime" or "datetime2" or "date" => typeof(DateTime),
                    _ => typeof(string)
                };
                mappedTable.Columns.Add(mapping.DbColumnName, dataType);
            }

            foreach (DataRow excelRow in excelData.Rows)
            {
                var mappedRow = mappedTable.NewRow();

                foreach (var mapping in columnMappings)
                {
                    var excelColumnIndex = excelData.Columns.IndexOf(mapping.ExcelColumnName);
                    if (excelColumnIndex >= 0 && excelColumnIndex < excelRow.ItemArray.Length)
                    {
                        var cellValue = excelRow[excelColumnIndex];

                        if (cellValue == null || cellValue == DBNull.Value || string.IsNullOrWhiteSpace(cellValue.ToString()))
                        {
                            if (mapping.IsRequired && string.IsNullOrEmpty(mapping.DefaultValue))
                            {
                                throw new Exception($"Required field '{mapping.ExcelColumnName}' is empty in row {excelData.Rows.IndexOf(excelRow) + 2}");
                            }
                            mappedRow[mapping.DbColumnName] = string.IsNullOrEmpty(mapping.DefaultValue) ? DBNull.Value : ConvertValue(mapping.DefaultValue, mapping.DataType);
                        }
                        else
                        {
                            mappedRow[mapping.DbColumnName] = ConvertValue(cellValue.ToString(), mapping.DataType);
                        }
                    }
                    else
                    {
                        mappedRow[mapping.DbColumnName] = string.IsNullOrEmpty(mapping.DefaultValue) ? DBNull.Value : ConvertValue(mapping.DefaultValue, mapping.DataType);
                    }
                }

                mappedTable.Rows.Add(mappedRow);
            }

            return mappedTable;
        }

        private object ConvertValue(string value, string dataType)
        {
            if (string.IsNullOrWhiteSpace(value))
                return DBNull.Value;

            try
            {
                return dataType.ToLowerInvariant() switch
                {
                    "int" or "integer" => int.Parse(value),
                    "bigint" or "long" => long.Parse(value),
                    "decimal" or "numeric" or "money" => decimal.Parse(value),
                    "float" or "real" => double.Parse(value),
                    "bit" or "boolean" => bool.Parse(value),
                    "datetime" or "datetime2" or "date" => DateTime.Parse(value),
                    _ => value
                };
            }
            catch
            {
                throw new Exception($"Cannot convert value '{value}' to type '{dataType}'");
            }
        }

        private async Task CreateTempTableAsync(SqlConnection connection, SqlTransaction transaction, string tableName, List<TImportColumnMapping> columnMappings)
        {
            var columns = string.Join(", ", columnMappings.Select(m =>
            {
                var sqlType = m.DataType.ToUpperInvariant() switch
                {
                    "INT" or "INTEGER" => "INT",
                    "BIGINT" or "LONG" => "BIGINT",
                    "DECIMAL" or "NUMERIC" => "DECIMAL(18,2)",
                    "MONEY" => "MONEY",
                    "FLOAT" or "REAL" => "FLOAT",
                    "BIT" or "BOOLEAN" => "BIT",
                    "DATETIME" or "DATETIME2" => "DATETIME2",
                    "DATE" => "DATE",
                    "NVARCHAR" => "NVARCHAR(MAX)",
                    "VARCHAR" => "VARCHAR(MAX)",
                    _ => "NVARCHAR(MAX)"
                };
                return $"[{m.DbColumnName}] {sqlType} NULL";
            }));

            var createTableSql = $"CREATE TABLE {tableName} ({columns})";

            using (var command = new SqlCommand(createTableSql, connection, transaction))
            {
                await command.ExecuteNonQueryAsync();
            }
        }
    }
}
