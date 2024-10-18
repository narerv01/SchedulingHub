using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Entities
{
	public class SSISDependency
	{
		public int SSISJobID { get; set; }
		public string DepSSISJobID { get; set; }  
		public string SSISProject { get; set; }
		public string SSISPackage { get; set; }
		public string DependencyType { get; set; } // e.g., "Normal" or "External"
		public bool Since { get; set; } // Represents the 'Since' property as a boolean

	}
}
