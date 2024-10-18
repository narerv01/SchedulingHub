using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Services
{
    public class SSISDependencyManager : ISSISDependencyManager
    {
        private readonly ISSISDependencyRepository _repository;
        
        public SSISDependencyManager(ISSISDependencyRepository repository)
        {
            _repository = repository;
        }


        public IEnumerable<SSISDependency> GetAllByJobId(int id)
        {
            return _repository.GetAllByJobId(id);
        }


        public SSISDependency GetDependencyByIds(int id, string idDep)
        {
            return _repository.GetByIds(id, idDep);
        }



        public bool AddDependency(int id, string idDep, bool since, bool isExternal)
        {
            // Check if id and idDep are the same
            if (id.ToString() == idDep)
            {
                return false;
            }

            // Check if the dependency already exists
            var existingDependency = _repository.GetByIds(id, idDep);
             
            if (existingDependency != null)
            {
                return false;
            }
            
            // Check dependency type
            if (isExternal)
            {
                _repository.AddExternal(id, idDep); 
            }
            else if(!isExternal)
            {
                _repository.AddNormal(id, idDep, since); 
            }
            else // if the dependency type is not valid
            {
                return false;
            }

            return true;
        } 


        public bool RemoveDependency(int id, string idDep)
        {
 
            var dependency = _repository.GetByIds(id, idDep);

            if (dependency == null)
            {
               return false; 
            }

            if (dependency.DependencyType == "Normal")
            { 
                _repository.RemoveNormal(id, idDep);
            }
            else if (dependency.DependencyType == "External")
            { 
                _repository.RemoveExternal(id, idDep);
            }
            else
            {
               return false;
            } 

            return true;
        }
    }
}
