using SchedulingHub.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Interfaces
{
	public interface ISSISJobRepository
    { 
        IEnumerable<SSISJob> GetAll();
        SSISJob GetJobById(int id);
        bool CreateJobWithSchedule(int id);
        bool EnableJob(int id);   
        bool DisableJob(int id, string description);
    }
}
