using SchedulingHub.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Interfaces
{
	public interface ISSISDependencyManager
    { 
        IEnumerable<SSISDependency> GetAllByJobId(int id);
        SSISDependency GetDependencyByIds(int id, string depId);
        bool AddDependency(int id, string depId, bool since, bool IsExternal);
        bool RemoveDependency(int id, string depId);
    }
}
