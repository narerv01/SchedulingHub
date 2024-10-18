
using SchedulingHub.Core;
using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Infrastructure.Repositories
{


    public class SSISDependencyRepository : ISSISDependencyRepository 
    {
		private readonly SqlDbContext _context;

		public SSISDependencyRepository(SqlDbContext context)
		{
			_context = context;
		}

        public void AddExternal(int id, string idDep)
        {
            using (var command = new SqlCommand("flju.SSIS_AddJobExternalDependencies", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));
                command.Parameters.Add(new SqlParameter("@DEP_external", idDep));

                command.ExecuteNonQuery();
            }
        }

        public void AddNormal(int id, string idDep, bool since)
        {
            using (var command = new SqlCommand("flju.SSIS_AddJobDependencies", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));
                command.Parameters.Add(new SqlParameter("@DEP_SSIS_Job_ID", idDep));
                command.Parameters.Add(new SqlParameter("@NoSince", (object)since ?? DBNull.Value));

                command.ExecuteNonQuery();
            }
        }

        public IEnumerable<SSISDependency> GetAllByJobId(int ssisJobId)
        {
            var dependencies = new List<SSISDependency>();
            using (var command = new SqlCommand("dbo.GetAllSSISDependenciesById", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", ssisJobId));
                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var dependency = new SSISDependency
                        {
                            SSISJobID = reader.GetInt32(0),
                            DepSSISJobID = reader.GetString(1),
                            SSISProject = reader.GetString(2),
                            SSISPackage = reader.GetString(3),
                            DependencyType = reader.GetString(4),
                            Since = reader.GetBoolean(5)
                        };
                        dependencies.Add(dependency);
                    }
                }
            }
            return dependencies;
        }

        public SSISDependency GetByIds(int id, string idDep)
        {
            SSISDependency dependency = null;

            using (var command = new SqlCommand("dbo.GetDependency", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));
                command.Parameters.Add(new SqlParameter("@DEP_SSIS_JOB_ID", idDep));

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        dependency = new SSISDependency
                        {
                            SSISJobID = reader.GetInt32(0),
                            DepSSISJobID = reader.GetString(1),
                            SSISProject = reader.GetString(2),
                            SSISPackage = reader.GetString(3),
                            DependencyType = reader.GetString(4),
                            Since = reader.GetBoolean(5)
                        };
                    }
                }
            }

            return dependency;
        }
         
        public void RemoveExternal(int id, string idDep)
        {
            using (var command = new SqlCommand("dbo.DeleteExternalDependency", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));
                command.Parameters.Add(new SqlParameter("@DEP_SSIS_JOB_ID", idDep));

                command.ExecuteNonQuery();
            }
        }

        public void RemoveNormal(int id, string idDep)
        {
            using (var command = new SqlCommand("dbo.DeleteNormalDependency", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));
                command.Parameters.Add(new SqlParameter("@DEP_SSIS_JOB_ID", idDep));

                command.ExecuteNonQuery();
            }
        }
    }
}
