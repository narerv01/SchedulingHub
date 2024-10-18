using System.Data.SqlClient;

namespace SchedulingHub.Infrastructure
{
	public class SqlDbContext : IDisposable
	{
		private readonly string _connectionString;
		private SqlConnection _connection;

		public SqlDbContext(string connectionString)
		{
			_connectionString = connectionString;
			_connection = new SqlConnection(_connectionString);
			_connection.Open();   
		}

		public SqlConnection Connection => _connection;

		public void Dispose()
		{
			_connection?.Close();
			_connection?.Dispose();
		}
	}
}
