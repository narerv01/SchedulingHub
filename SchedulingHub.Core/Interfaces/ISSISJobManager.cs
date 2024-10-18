using SchedulingHub.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Interfaces
{
	public interface ISSISJobManager
	{

		bool CreateJobWithSchedule(int id);
		bool ToggleEnableDisable(int id, string description);
        IEnumerable<SSISJob> GetAll();
		SSISJob GetJobById(int id);
    }
}
