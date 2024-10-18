using Microsoft.AspNetCore.Mvc;
using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using SchedulingHub.Core.Services;
using SchedulingHub.Infrastructure.Repositories;

namespace SchedulingHub.WebApi.Controllers
{
	[ApiController]
	[Route("[controller]")]
	public class SSISDependencyController : ControllerBase
    {
		private readonly ISSISDependencyManager _ssisDependencyManager; 

		public SSISDependencyController(ISSISDependencyManager manager)
		{
            _ssisDependencyManager = manager; 
		}

        [HttpGet("GetAllByJobId/{ssisJobId}")]
        public IEnumerable<SSISDependency> GetAllByJobId(int ssisJobId)
        {
            return _ssisDependencyManager.GetAllByJobId(ssisJobId);
        }
         

        [HttpGet("GetByIds/{id}/{idDep}")]
        public IActionResult GetByIds(int id, string idDep)
        {
            var dependency = _ssisDependencyManager.GetDependencyByIds(id, idDep);
            if (dependency == null)
            {
                return NotFound(); 
            }
            return Ok(dependency);   
        }


        [HttpDelete("RemoveByIds/{id}/{idDep}")]
        public IActionResult RemoveByIds(int id, string idDep)
        {  
            if (_ssisDependencyManager.RemoveDependency(id, idDep))
            {
                return Ok("Dependency Removed");

            }
            return BadRequest();
        }

        [HttpPost("AddDependency/{id}/{idDep}/{since}/{isExternal}")]
        public IActionResult AddDependency(int id, string idDep, bool since, bool isExternal)
        { 
         
            if(_ssisDependencyManager.AddDependency(id, idDep, since, isExternal))
            {
                return Ok("Dependency Added");

            }
            return BadRequest(); 
        }

    }
}
