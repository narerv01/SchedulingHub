
using Castle.Core.Resource;
using Moq;
using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using SchedulingHub.Core.Services;
using Xunit; 

namespace SchedulingHub.UnitTests
{
    public class SSISDependencyManagerTests
    {
        private readonly ISSISDependencyManager _ssisDependencyManager;

        private readonly Mock<ISSISDependencyRepository> _mockDependencyRepository;
        private readonly Mock<ISSISJobRepository> _mockSSISJobRepository;
        private readonly Mock<IRepository<Schedule>> _mockScheduleRepository;

        private readonly List<SSISDependency> _ssisDependencies;
        private readonly List<SSISJob> _ssisJobs;
        private readonly List<Schedule> _schedules; 


        public SSISDependencyManagerTests()
        {

 
            _mockDependencyRepository = new Mock<ISSISDependencyRepository>();
            _mockSSISJobRepository = new Mock<ISSISJobRepository>();
            _mockScheduleRepository = new Mock<IRepository<Schedule>>();

            _ssisDependencyManager = new SSISDependencyManager(_mockDependencyRepository.Object);

            _schedules = new List<Schedule>
            {
                new Schedule { ID = 1, JAMSSchedule = "workdays" },
                new Schedule { ID = 2, JAMSSchedule = "last workday of month" }, 
            };
            _ssisJobs = new List<SSISJob>
            {
                new SSISJob { SSISJobID = 1, SSISProject = "TestProject", SSISPackage = "TestPackage1", SSISFolder = "DHUB", IsEnabled = true, ScheduleID = 1, JAMSSchedule = "workdays"},
                new SSISJob { SSISJobID = 2, SSISProject = "TestProject", SSISPackage = "TestPackage2", SSISFolder = "DHUB", IsEnabled = true, ScheduleID = 1, JAMSSchedule = "workdays"},
                new SSISJob { SSISJobID = 3, SSISProject = "TestProject", SSISPackage = "TestPackage3", SSISFolder = "DHUB", IsEnabled = true, ScheduleID = 1, JAMSSchedule = "workdays"},
                new SSISJob { SSISJobID = 4, SSISProject = "TestProject", SSISPackage = "TestPackage4", SSISFolder = "DHUB", IsEnabled = true, ScheduleID = 1, JAMSSchedule = "workdays"},
            };

            _ssisDependencies = new List<SSISDependency>
            {
                new SSISDependency { SSISJobID = 2, DepSSISJobID = "1", SSISProject = "TestProject", SSISPackage = "TestPackage1", DependencyType = "Normal", Since = true},
                new SSISDependency { SSISJobID = 3, DepSSISJobID = "1", SSISProject = "TestProject", SSISPackage = "TestProject2", DependencyType = "Normal", Since = true}, 
                new SSISDependency { SSISJobID = 4, DepSSISJobID = "ONL01Z123", SSISProject = "TestProject", SSISPackage = "TestProject2", DependencyType = "External", Since = true},
            };

            _mockSSISJobRepository.Setup(x => x.GetAll()).Returns(_ssisJobs);
            _mockScheduleRepository.Setup(x => x.GetAll()).Returns(_schedules); 
            _mockDependencyRepository.Setup(x => x.GetAllByJobId(It.IsAny<int>())).Returns(_ssisDependencies);

            _mockDependencyRepository.Setup(x => x.GetByIds(It.IsAny<int>(), It.IsAny<string>()))
                .Returns((int id, string idDep) => _ssisDependencies.FirstOrDefault(y => y.SSISJobID == id && y.DepSSISJobID == idDep));


            _mockDependencyRepository.Setup(x => x.AddNormal(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<bool>()));
            _mockDependencyRepository.Setup(x => x.AddExternal(It.IsAny<int>(), It.IsAny<string>()));

            _mockDependencyRepository.Setup(x => x.RemoveNormal(It.IsAny<int>(), It.IsAny<string>()));
            _mockDependencyRepository.Setup(x => x.RemoveExternal(It.IsAny<int>(), It.IsAny<string>()));

        }


        [Fact]
        public void AddDependency_SameId_ReturnsFalse()
        {
            // Arrange
            int id = 1;
            string idDep = "1";
            bool isExternal = true;
            bool since = true;  
              
            // Act
            bool result = _ssisDependencyManager.AddDependency(id, idDep, since, isExternal);

            // Assert
            _mockDependencyRepository.Verify(x => x.AddNormal(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<bool>()), Times.Never);
            _mockDependencyRepository.Verify(x => x.AddExternal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
            Assert.False(result);
        }

        [Fact]
        public void AddDependency_AlreadyExists_ReturnsFalse()
        {
            // Arrange
            int id = 2;
            string idDep = "1";
            bool isExternal = false;
            bool since = true;
             
            // Act
            bool result = _ssisDependencyManager.AddDependency(id, idDep, since, isExternal);

            // Assert 
            _mockDependencyRepository.Verify(x => x.AddNormal(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<bool>()), Times.Never);
            _mockDependencyRepository.Verify(x => x.AddExternal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
            Assert.False(result);
        }


        [Fact]
        public void AddDependency_NormalTypeAddedNormalDep_ReturnsTrue()
        {
            // Arrange
            int id = 4;
            string idDep = "1";
            bool isExternal = false;
            bool since = true;

            // Act
            bool result = _ssisDependencyManager.AddDependency(id, idDep, since, isExternal);

            // Assert
            _mockDependencyRepository.Verify(x => x.AddNormal(id, idDep, since), Times.Once);
            _mockDependencyRepository.Verify(x => x.AddExternal(id, idDep), Times.Never); 
            Assert.True(result);
        }

        [Fact]
        public void AddDependency_ExternalTypeAddedExternalDep_ReturnsTrue()
        {
            int id = 4;
            string idDep = "1";
            bool isExternal = true;
            bool since = true;

            // Act
            bool result = _ssisDependencyManager.AddDependency(id, idDep, since, isExternal);

            // Assert
            _mockDependencyRepository.Verify(x => x.AddExternal(id, idDep), Times.Once);
            _mockDependencyRepository.Verify(x => x.AddNormal(id, idDep, since), Times.Never); 
            Assert.True(result);
        }


        //----------------------------------------------------------------------------


        [Fact]
        public void RemoveDependency_NonExistent_ReturnsFalse()
        {
            // Arrange
            int id = 99; 
            string idDep = "non-existent";

            // Act
            bool result = _ssisDependencyManager.RemoveDependency(id, idDep);

            // Assert
            Assert.False(result);
            _mockDependencyRepository.Verify(x => x.RemoveNormal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
            _mockDependencyRepository.Verify(x => x.RemoveExternal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
        }

        [Fact]
        public void RemoveDependency_NormalType_ReturnsTrue()
        {
            // Arrange
            int id = 2;  
            string idDep = "1";

            // Act
            bool result = _ssisDependencyManager.RemoveDependency(id, idDep);

            // Assert
            Assert.True(result);
            _mockDependencyRepository.Verify(x => x.RemoveNormal(id, idDep), Times.Once);
            _mockDependencyRepository.Verify(x => x.RemoveExternal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
        }

        [Fact]
        public void RemoveDependency_ExternalType_ReturnsTrue()
        {
            // Arrange
            int id = 4;  
            string idDep = "ONL01Z123";

            // Act
            bool result = _ssisDependencyManager.RemoveDependency(id, idDep);

            // Assert
            Assert.True(result);
            _mockDependencyRepository.Verify(x => x.RemoveExternal(id, idDep), Times.Once);
            _mockDependencyRepository.Verify(x => x.RemoveNormal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
        }

        [Fact]
        public void RemoveDependency_InvalidDependencyType_ReturnsFalse()
        {
            // Arrange 
            var invalidDependency = new SSISDependency { SSISJobID = 4, DepSSISJobID = "3", DependencyType = "Invalid" }; 
            _ssisDependencies.Add(invalidDependency); 
            int id = 4;
            string idDep = "3";

            // Act
            bool result = _ssisDependencyManager.RemoveDependency(id, idDep);

            // Assert
            Assert.False(result);
            _mockDependencyRepository.Verify(x => x.RemoveNormal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
            _mockDependencyRepository.Verify(x => x.RemoveExternal(It.IsAny<int>(), It.IsAny<string>()), Times.Never);
        }

    }
}