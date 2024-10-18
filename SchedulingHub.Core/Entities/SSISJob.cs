using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulingHub.Core.Entities
{
	public class SSISJob
	{
		public int SSISJobID { get; set; }
		public string SSISFolder { get; set; }
		public string SSISProject { get; set; }
		public string SSISPackage { get; set; }
		public bool IsEnabled { get; set; }
		public int? ScheduleID { get; set; } // Nullable in case there's no schedule
		public string JAMSSchedule { get; set; } // From related schedule
	}
}
