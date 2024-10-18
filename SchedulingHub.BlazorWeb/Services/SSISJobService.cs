using SchedulingHub.Core.Entities;
using System.Net.Http.Json;

namespace SchedulingHub.BlazorWebAssembly.Services
{
	public class SSISJobService
	{
		private readonly HttpClient _httpClient;

		public SSISJobService(HttpClient httpClient)
		{
			_httpClient = httpClient;
		}

        public async Task<IEnumerable<SSISJob>> GetJobsAsync()
        {
            return await _httpClient.GetFromJsonAsync<IEnumerable<SSISJob>>("SSISJob/GetAll");
        }
    }
}
