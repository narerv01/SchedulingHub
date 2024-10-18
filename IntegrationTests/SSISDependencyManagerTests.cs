 
using SchedulingHub.Core.Interfaces;
using SchedulingHub.Core.Services;
using SchedulingHub.Infrastructure; 
using SchedulingHub.Infrastructure.Repositories; 

namespace IntegrationTests
{
    [TestClass]
    public class SSISDependencyManagerTests
    {
        private SqlDbContext _dbContext;
        private ISSISDependencyRepository _repository;
        private ISSISDependencyManager _ssisDependencyManager;

        public SSISDependencyManagerTests()
        { 
        }

        [TestInitialize]
        public void Setup()
        {
   
            var connectionString = "Initial Catalog=SSISDrift;Data Source=preprod.sql.dhub.sydbank.net;Integrated Security=SSPI";
            _dbContext = new SqlDbContext(connectionString);
            _repository = new SSISDependencyRepository(_dbContext); 
            _ssisDependencyManager = new SSISDependencyManager(_repository);
 
        }


        [TestMethod]
        public void Test_AddDependency_Success()
        {
            // Arrange
            var ssisJobID = 4045;  
            var depSSISJobID = "3348"; 
            var dependencyType = "Normal";  

            // Act
            var result = _ssisDependencyManager.AddDependency(ssisJobID, depSSISJobID, true, false);

            // Assert
            Assert.IsTrue(result, "Expected the addition of the dependency to succeed.");

            // Verify the dependency was added
            var addedDependency = _repository.GetByIds(ssisJobID, depSSISJobID);
            Assert.IsNotNull(addedDependency, "Expected the dependency to be found in the database after addition.");
        }

        [TestMethod]
        public void Test_RemoveDependency_Success()
        {
            // Arrange
            var ssisJobID = 4045; 
            var depSSISJobID = "3348"; 
             
            var initialDependency = _repository.GetByIds(ssisJobID, depSSISJobID);
            Assert.IsNotNull(initialDependency, "Expected the dependency to exist before removal.");

            // Act
            var result = _ssisDependencyManager.RemoveDependency(ssisJobID, depSSISJobID);

            // Assert
            Assert.IsTrue(result, "Expected the removal of the dependency to succeed.");

            // Verify the dependency was removed
            var removedDependency = _repository.GetByIds(ssisJobID, depSSISJobID);
            Assert.IsNull(removedDependency, "Expected the dependency to be removed from the database.");
        }
    }
}