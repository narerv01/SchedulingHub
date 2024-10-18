using SchedulingHub.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Interfaces
{
	public interface ISSISDependencyRepository 
    {
        IEnumerable<SSISDependency> GetAllByJobId(int id);  
        SSISDependency GetByIds(int id, string depId);
        
        void RemoveNormal(int id, string depId);
        void RemoveExternal(int id, string depId); 
        
        void AddNormal(int id, string depId, bool since);
        void AddExternal(int id, string depId);
    }
}
