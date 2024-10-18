
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

	public class SSISJobRepository : ISSISJobRepository
	{
		private readonly SqlDbContext _context;

		public SSISJobRepository(SqlDbContext context)
		{
			_context = context;
		}

        public bool CreateJobWithSchedule(int id)
        {
            throw new NotImplementedException();
        }

        public bool DisableJob(int id, string description)
        {
            using (var command = new SqlCommand("flju.SSIS_JobDisable", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));
                command.Parameters.Add(new SqlParameter("@Bemaerkning", description));

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        if (!(bool)reader["isEnabled"])
                        {
                            return true;
                        }
                    }

                }
            }
            return false;
        }

		public bool EnableJob(int id)
		{
			using (var command = new SqlCommand("flju.SSIS_JobEnable", _context.Connection))
			{
                command.CommandType = CommandType.StoredProcedure; 
                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
						if ((bool)reader["isEnabled"])
						{
							return true;
                        }
                    }

                }
            }
			return false;
			
		}

        public IEnumerable<SSISJob> GetAll()
		{
			var jobSchedules = new List<SSISJob>();
 
				using (var command = new SqlCommand("dbo.GetAllSSISJobs", _context.Connection))
				{
					command.CommandType = CommandType.StoredProcedure;

					using (var reader = command.ExecuteReader())
					{
						while (reader.Read())
						{
							var jobSchedule = new SSISJob
							{
								SSISJobID = reader.GetInt32(0),
								SSISFolder = reader.GetString(1),
								SSISProject = reader.GetString(2),
								SSISPackage = reader.GetString(3),
								IsEnabled = reader.GetBoolean(4),
								ScheduleID = reader.IsDBNull(5) ? (int?)null : reader.GetInt32(5),
								JAMSSchedule = reader.IsDBNull(6) ? null : reader.GetString(6)
							};
							jobSchedules.Add(jobSchedule);
						}
					}
				}
			 
			return jobSchedules;
			 
		}

        public SSISJob GetJobById(int id)
        {
            using (var command = new SqlCommand("dbo.GetSSISJob", _context.Connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@SSIS_Job_ID", id));

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        var job = new SSISJob
                        {
                            SSISJobID = reader.GetInt32(0),
                            SSISFolder = reader.GetString(1),
                            SSISProject = reader.GetString(2),
                            SSISPackage = reader.GetString(3),
                            IsEnabled = reader.GetBoolean(4),
                            ScheduleID = reader.IsDBNull(5) ? (int?)null : reader.GetInt32(5),
                            JAMSSchedule = reader.IsDBNull(6) ? null : reader.GetString(6)
                        };
                        return job;
                    }
                }
            }
            return null;
        }
    }
}
