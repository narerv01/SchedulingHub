using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Services
{
    public class SSISJobManager : ISSISJobManager
    {
        private readonly ISSISJobRepository _repository;

        public SSISJobManager(ISSISJobRepository repository)
        {
            _repository = repository;
        }

        public bool CreateJobWithSchedule(int id)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<SSISJob> GetAll()
        {
            return _repository.GetAll();
        }
        public SSISJob GetJobById(int id)
        {
            return _repository.GetJobById(id);
        }

        public bool ToggleEnableDisable(int id, string description)
        {
            var job = _repository.GetJobById(id);

            if (job != null)
            {
                if (job.IsEnabled)
                {
                    _repository.DisableJob(id, description);
                }
                else
                {
                    _repository.EnableJob(id);
                }
                return true;
            }
            return false;
        }
    }
}
