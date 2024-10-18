using Microsoft.AspNetCore.Mvc;
using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using SchedulingHub.Core.Services;
using SchedulingHub.Infrastructure.Repositories;

namespace SchedulingHub.WebApi.Controllers
{
	[ApiController]
	[Route("[controller]")]
	public class ScheduleController : ControllerBase
    {
		private readonly IRepository<Schedule> scheduleRepository; 

		public ScheduleController(IRepository<Schedule> repos)
		{
            scheduleRepository = repos; 
		}

		[HttpGet("GetAll")]
		public IEnumerable<Schedule> GetAll()
		{
			return scheduleRepository.GetAll();
		}
 
	}
}
