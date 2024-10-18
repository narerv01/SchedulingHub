
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

	public class ScheduleRepository : IRepository<Schedule>
	{
		private readonly SqlDbContext _context;

		public ScheduleRepository(SqlDbContext context)
		{
			_context = context;
		}
         
        public IEnumerable<Schedule> GetAll()
		{
			var schedules = new List<Schedule>();
 
				using (var command = new SqlCommand("dbo.GetAllSchedules", _context.Connection))
				{
                command.CommandType = CommandType.StoredProcedure;
				
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var schedule = new Schedule
                            {
                                ID = reader.GetInt32(0),
                                JAMSSchedule = reader.GetString(1)
                            };
                            schedules.Add(schedule);
                        }
                    }

				}

            return schedules;
			 
		}

        public IEnumerable<Schedule> GetAllByJobId(int id)
        {
            throw new NotImplementedException();
        }

        public Schedule GetByIds(int id, string idDep)
        {
            throw new NotImplementedException();
        }

        public void Remove(int id)
        {
            throw new NotImplementedException();
        }

        public void Add(Schedule entity)
        {
            throw new NotImplementedException();
        }

        public void Edit(Schedule entity)
        {
            throw new NotImplementedException();
        }

        public Schedule Get(int id)
        {
            throw new NotImplementedException();
        }

        public void RemoveByIds(int id, string idDep)
        {
            throw new NotImplementedException();
        }
    }
}
