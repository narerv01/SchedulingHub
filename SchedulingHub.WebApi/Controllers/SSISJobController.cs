using Microsoft.AspNetCore.Mvc;
using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using SchedulingHub.Core.Services;
using SchedulingHub.Infrastructure.Repositories;

namespace SchedulingHub.WebApi.Controllers
{
	[ApiController]
	[Route("[controller]")]
	public class SSISJobController : ControllerBase
    {
        private readonly ISSISJobManager _ssisJobManager;

		public SSISJobController(ISSISJobManager manager)
		{
			_ssisJobManager = manager;
		}

        [HttpGet("GetAll")]
		public IEnumerable<SSISJob> GetAll()
		{
			return _ssisJobManager.GetAll();
		}

        [HttpGet("GetJobById/{id}")]
        public SSISJob GetJobById(int id)
        {
            return _ssisJobManager.GetJobById(id);
        }

        [HttpPost("ToggleEnableDisable/{id}")]
        public IActionResult ToggleEnableDisable(int id, string description)
        {
 
            if (_ssisJobManager.ToggleEnableDisable(id, description))
            {
                return Ok("Job updated");

            }
            return BadRequest();
        }

    }
}
