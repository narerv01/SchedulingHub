USE [SSISDrift]
GO
/****** Object:  Table [dbo].[SSIS_Dependencies]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_Dependencies](
	[SSIS_folder] [nvarchar](200) NULL,
	[SSIS_project] [nvarchar](200) NULL,
	[SSIS_package] [nvarchar](200) NULL,
	[DEP_SSIS_folder] [nvarchar](200) NULL,
	[DEP_SSIS_project] [nvarchar](200) NULL,
	[DEP_SSIS_package] [nvarchar](200) NULL,
	[DEP_external] [nvarchar](200) NULL,
	[Notification] [nvarchar](200) NULL,
	[Notify] [nvarchar](200) NULL,
	[Retry] [nvarchar](200) NULL,
	[RepeatPeriod] [nvarchar](200) NULL,
	[Time] [datetime] NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[Definition] [nvarchar](200) NULL,
	[Description] [nvarchar](200) NULL,
	[ScheduleID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_External]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_External](
	[DEP_external] [varchar](200) NOT NULL,
	[Beskrivelse] [varchar](500) NULL,
 CONSTRAINT [IX_SSIS_external] UNIQUE CLUSTERED 
(
	[DEP_external] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_Job]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_Job](
	[SSIS_Job_ID] [int] IDENTITY(1,1) NOT NULL,
	[SSIS_folder] [nvarchar](50) NOT NULL,
	[SSIS_project] [nvarchar](100) NOT NULL,
	[SSIS_package] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
	[Notification] [nvarchar](200) NULL,
	[Notify] [nvarchar](200) NULL,
	[Retry] [int] NOT NULL,
	[RepeatPeriod] [int] NOT NULL,
	[isEnabled] [bit] NOT NULL,
	[OnHold] [bit] NOT NULL,
 CONSTRAINT [PK_SSIS_Job] PRIMARY KEY CLUSTERED 
(
	[SSIS_folder] ASC,
	[SSIS_project] ASC,
	[SSIS_package] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_Job_Dependencies]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_Job_Dependencies](
	[SSIS_Job_ID] [int] NOT NULL,
	[DEP_SSIS_Job_ID] [int] NOT NULL,
	[Since] [bit] NOT NULL,
 CONSTRAINT [PK_SSIS_Job_Dependencies] PRIMARY KEY CLUSTERED 
(
	[SSIS_Job_ID] ASC,
	[DEP_SSIS_Job_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_Job_External_Dependencies]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_Job_External_Dependencies](
	[SSIS_Job_ID] [int] NOT NULL,
	[DEP_external] [nvarchar](200) NOT NULL,
	[Since] [bit] NOT NULL,
	[ScheduleID] [int] NOT NULL,
 CONSTRAINT [PK_SSIS_Job_External_Dependencies] PRIMARY KEY CLUSTERED 
(
	[SSIS_Job_ID] ASC,
	[DEP_external] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_Job_Schedule]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_Job_Schedule](
	[SSIS_Job_ID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
 CONSTRAINT [PK_SSIS_Job_Schedule] PRIMARY KEY CLUSTERED 
(
	[SSIS_Job_ID] ASC,
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_Schedule]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_Schedule](
	[ID] [int] NOT NULL,
	[JAMSSchedule] [nvarchar](1000) NOT NULL,
	[Kalender] [nvarchar](500) NOT NULL,
	[Beskrivelse] [nvarchar](500) NOT NULL,
	[StartTidspunkt] [time](0) NOT NULL,
	[Undtagen] [nvarchar](500) NOT NULL,
	[ForretningsvendtBeskrivelse] [nvarchar](500) NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SSIS_Dependencies] ADD  CONSTRAINT [DF_SSIS_Dependencies_Schedule]  DEFAULT ((1)) FOR [ScheduleID]
GO
ALTER TABLE [dbo].[SSIS_Job] ADD  CONSTRAINT [DF_SSIS_Job_Retry]  DEFAULT ((0)) FOR [Retry]
GO
ALTER TABLE [dbo].[SSIS_Job] ADD  CONSTRAINT [DF_SSIS_Job_RepeatPeriod]  DEFAULT ((0)) FOR [RepeatPeriod]
GO
ALTER TABLE [dbo].[SSIS_Job] ADD  CONSTRAINT [DF_SSIS_Job_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
ALTER TABLE [dbo].[SSIS_Job_External_Dependencies] ADD  CONSTRAINT [DF_SSIS_Job_External_Dependencies_Since]  DEFAULT ((0)) FOR [Since]
GO
ALTER TABLE [dbo].[SSIS_Job_External_Dependencies] ADD  CONSTRAINT [DF_SSIS_Job_External_Dependencies_ScheduleID]  DEFAULT ((0)) FOR [ScheduleID]
GO
ALTER TABLE [dbo].[SSIS_Schedule] ADD  CONSTRAINT [DF_SSIS_Schedule_Undtagen]  DEFAULT (N'Helligdag') FOR [Undtagen]
GO
ALTER TABLE [dbo].[SSIS_Job_Dependencies]  WITH CHECK ADD  CONSTRAINT [FK_SSIS_Job_Dependencies_SSIS_Job] FOREIGN KEY([SSIS_Job_ID])
REFERENCES [dbo].[SSIS_Job] ([SSIS_Job_ID])
GO
ALTER TABLE [dbo].[SSIS_Job_Dependencies] CHECK CONSTRAINT [FK_SSIS_Job_Dependencies_SSIS_Job]
GO
ALTER TABLE [dbo].[SSIS_Job_Dependencies]  WITH CHECK ADD  CONSTRAINT [FK_SSIS_Job_Dependencies_SSIS_Job1] FOREIGN KEY([DEP_SSIS_Job_ID])
REFERENCES [dbo].[SSIS_Job] ([SSIS_Job_ID])
GO
ALTER TABLE [dbo].[SSIS_Job_Dependencies] CHECK CONSTRAINT [FK_SSIS_Job_Dependencies_SSIS_Job1]
GO
ALTER TABLE [dbo].[SSIS_Job_External_Dependencies]  WITH CHECK ADD  CONSTRAINT [FK_SSIS_Job_External_Dependencies_SSIS_Job] FOREIGN KEY([SSIS_Job_ID])
REFERENCES [dbo].[SSIS_Job] ([SSIS_Job_ID])
GO
ALTER TABLE [dbo].[SSIS_Job_External_Dependencies] CHECK CONSTRAINT [FK_SSIS_Job_External_Dependencies_SSIS_Job]
GO
ALTER TABLE [dbo].[SSIS_Job_Schedule]  WITH CHECK ADD  CONSTRAINT [FK_SSIS_Job_Schedule_SSIS_Job] FOREIGN KEY([SSIS_Job_ID])
REFERENCES [dbo].[SSIS_Job] ([SSIS_Job_ID])
GO
ALTER TABLE [dbo].[SSIS_Job_Schedule] CHECK CONSTRAINT [FK_SSIS_Job_Schedule_SSIS_Job]
GO
ALTER TABLE [dbo].[SSIS_Job_Schedule]  WITH CHECK ADD  CONSTRAINT [FK_SSIS_Job_Schedule_SSIS_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[SSIS_Schedule] ([ID])
GO
ALTER TABLE [dbo].[SSIS_Job_Schedule] CHECK CONSTRAINT [FK_SSIS_Job_Schedule_SSIS_Schedule]
GO
/****** Object:  StoredProcedure [dbo].[DeleteExternalDependency]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DeleteExternalDependency] @SSIS_Job_ID INT , @DEP_SSIS_JOB_ID NVARCHAR(200)
AS

DELETE FROM dbo.SSIS_Job_External_Dependencies 
WHERE SSIS_Job_ID = @SSIS_Job_ID AND DEP_external = @DEP_SSIS_JOB_ID 
GO
/****** Object:  StoredProcedure [dbo].[DeleteNormalDependency]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DeleteNormalDependency] @SSIS_Job_ID INT , @DEP_SSIS_JOB_ID INT
AS

DELETE FROM dbo.SSIS_Job_Dependencies  
WHERE SSIS_JOB_ID =  @SSIS_JOB_ID AND DEP_SSIS_JOB_ID = @DEP_SSIS_JOB_ID
GO
/****** Object:  StoredProcedure [dbo].[GetAllSchedules]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAllSchedules]
AS


SELECT  ID
      , JAMSSchedule 
FROM SSISDrift.dbo.SSIS_Schedule
GO
/****** Object:  StoredProcedure [dbo].[GetAllSSISDependenciesById]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAllSSISDependenciesById] @SSIS_Job_ID INT 
AS

SELECT a.SSIS_Job_ID
     , CAST(a.DEP_SSIS_Job_ID As VARCHAR(20)) DEP_SSIS_Job_ID
     , b.SSIS_project
     , b.SSIS_package
					, 'Normal' DependencyType
					, a.Since
FROM SSISDrift.dbo.SSIS_Job_Dependencies a 
INNER JOIN SSISDrift.dbo.SSIS_Job b On b.SSIS_Job_ID = a.DEP_SSIS_Job_ID 
WHERE a.SSIS_Job_ID = @SSIS_Job_ID
UNION 
Select a.SSIS_Job_ID
     , a.DEP_external DEP_SSIS_Job_ID
     , b.SSIS_project
     , a.DEP_external
					, 'External' DependencyType
					, a.Since
FROM SSISDrift.dbo.SSIS_Job_External_Dependencies a 
INNER JOIN SSISDrift.dbo.SSIS_Job b On b.SSIS_Job_ID = a.SSIS_Job_ID  
WHERE a.SSIS_Job_ID = @SSIS_Job_ID
GO
/****** Object:  StoredProcedure [dbo].[GetAllSSISJobs]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAllSSISJobs]
AS
 
SELECT a.SSIS_Job_ID,
       a.SSIS_folder,
       a.SSIS_project,
       a.SSIS_package, 
       a.isEnabled ,
       b.ScheduleID, 
       c.JAMSSchedule 
FROM SSISDrift.dbo.SSIS_Job a 
LEFT JOIN SSISDrift.dbo.SSIS_Job_Schedule b ON b.SSIS_Job_ID = a.SSIS_Job_ID 
LEFT JOIN SSISDrift.dbo.SSIS_Schedule c ON c.ID = b.ScheduleID 
GO
/****** Object:  StoredProcedure [dbo].[GetDependency]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetDependency] @SSIS_Job_ID INT , @DEP_SSIS_JOB_ID INT

AS

SELECT a.SSIS_Job_ID
     , CAST(a.DEP_SSIS_Job_ID As VARCHAR(20)) DEP_SSIS_Job_ID
     , b.SSIS_project
     , b.SSIS_package
					, 'Normal' DependencyType
					, a.Since
FROM SSISDrift.dbo.SSIS_Job_Dependencies a 
INNER JOIN SSISDrift.dbo.SSIS_Job b On b.SSIS_Job_ID = a.DEP_SSIS_Job_ID 
WHERE @SSIS_Job_ID = a.SSIS_Job_ID AND  @DEP_SSIS_JOB_ID = DEP_SSIS_Job_ID
UNION 
Select a.SSIS_Job_ID
     , a.DEP_external DEP_SSIS_Job_ID
     , b.SSIS_project
     , a.DEP_external
					, 'External' DependencyType
					, a.Since
FROM SSISDrift.dbo.SSIS_Job_External_Dependencies a 
INNER JOIN SSISDrift.dbo.SSIS_Job b On b.SSIS_Job_ID = a.SSIS_Job_ID  
WHERE @SSIS_Job_ID = a.SSIS_Job_ID AND  @DEP_SSIS_JOB_ID = a.DEP_external
GO
/****** Object:  StoredProcedure [dbo].[GetSSISJob]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetSSISJob] @SSIS_Job_ID INT 
AS
 
SELECT a.SSIS_Job_ID,
       a.SSIS_folder,
       a.SSIS_project,
       a.SSIS_package, 
       a.isEnabled ,
       b.ScheduleID, 
       c.JAMSSchedule 
FROM SSISDrift.dbo.SSIS_Job a 
LEFT JOIN SSISDrift.dbo.SSIS_Job_Schedule b ON b.SSIS_Job_ID = a.SSIS_Job_ID 
LEFT JOIN SSISDrift.dbo.SSIS_Schedule c ON c.ID = b.ScheduleID 
WHERE a.SSIS_Job_ID = @SSIS_Job_ID
GO
/****** Object:  StoredProcedure [flju].[SSIS_AddJobDependencies]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		FLJU
-- Create date: Engang i 2019
-- Description:	Tilføjer Afhængigheder
-- Ændringer  : 2020-09-20 CPBP tilføjet since parameter til at overstyre automatik
--            : 2021-01-14 FLJU Kontrol for at en pakke ikke gøres afhængig af sig selv
-- =============================================
CREATE PROCEDURE [flju].[SSIS_AddJobDependencies]
    @SSIS_Job_ID INT,
    @DEP_SSIS_Job_ID INT,
	@NoSince BIT = 0
AS
BEGIN
	IF @SSIS_Job_ID = @DEP_SSIS_Job_ID 
		THROW 50000,'Error: Job_ID = DEP_Job_ID',1

	DECLARE
		@Since BIT = 0,
	    @ScheduleID INT,
		@DEP_ScheduleID INT

	SELECT @ScheduleID = ScheduleID 
		FROM dbo.SSIS_Job_Schedule sjs
		WHERE sjs.SSIS_Job_ID = @SSIS_Job_ID

	SELECT @DEP_ScheduleID = ScheduleID 
		FROM dbo.SSIS_Job_Schedule sjs
		WHERE sjs.SSIS_Job_ID = @DEP_SSIS_Job_ID

	IF @NoSince=0 
		AND NOT (@ScheduleID = 1 AND @DEP_ScheduleID = 2) -- denne kombi skal ikke have since
		AND @ScheduleID <> @DEP_ScheduleID 
		SELECT @Since = 1

	INSERT INTO dbo.SSIS_Job_Dependencies
	(
		SSIS_Job_ID,
	    DEP_SSIS_Job_ID,
		Since
	)
	VALUES
	(	
		@SSIS_Job_ID, -- SSIS_Job_ID - int
		@DEP_SSIS_Job_ID,  -- DEP_SSIS_Job_ID - int
		@Since -- Since=0 job skal køres i samme plan. Since = 1 Ud fra status for seneste kørsel. 
    )
	SELECT * FROM dbo.SSIS_Job WHERE SSIS_Job_ID = @DEP_SSIS_Job_ID
END
GO
/****** Object:  StoredProcedure [flju].[SSIS_AddJobExternalDependencies]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [flju].[SSIS_AddJobExternalDependencies]
    @SSIS_Job_ID INT,
    @DEP_external NVARCHAR(200)
AS
BEGIN
INSERT INTO dbo.SSIS_Job_External_Dependencies
(
    SSIS_Job_ID,
    DEP_external
)
VALUES
(   @SSIS_Job_ID,  -- SSIS_Job_ID - int
    @DEP_external -- DEP_external - nvarchar(200)
    )
	SELECT * FROM dbo.SSIS_Job_External_Dependencies WHERE SSIS_Job_ID = @SSIS_Job_ID
END
GO
/****** Object:  StoredProcedure [flju].[SSIS_AddJobSchedule]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [flju].[SSIS_AddJobSchedule]
    @SSIS_Job_ID INT,
    @ScheduleID INT
AS
BEGIN
	IF EXISTS (SELECT * FROM dbo.SSIS_Job_Schedule 
	WHERE SSIS_Job_ID = @SSIS_Job_ID)
	BEGIN 
		RAISERROR ('Job har allerde en schedulering',16,1)
		RETURN 0;  
	END 

	INSERT INTO dbo.SSIS_Job_Schedule
	(
		SSIS_Job_ID,
		ScheduleID
	)
	VALUES
	(   @SSIS_Job_ID, -- SSIS_Job_ID - int
		@ScheduleID  -- ScheduleID - int
		)
		SELECT * FROM dbo.SSIS_Schedule WHERE ID = @ScheduleID
END
GO
/****** Object:  StoredProcedure [flju].[SSIS_CreateJob]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [flju].[SSIS_CreateJob] 
	@SSIS_folder NVARCHAR(50),
	@SSIS_project NVARCHAR(100),
	@SSIS_package NVARCHAR(100)
AS
BEGIN
	DECLARE @SSIS_folder_ID INT,
			@SSIS_project_ID INT,
			@Retry INT = 0

	SELECT @SSIS_folder_ID = folder_id FROM SSISDB.internal.folders WHERE name = @SSIS_folder
	IF @SSIS_folder_ID IS NULL
	BEGIN
	  PRINT 'SSIS folder findes ikke i SSIS kataloget'
	  RETURN 0
	END

	SELECT @SSIS_project_ID = project_id FROM SSISDB.catalog.projects WHERE name = @SSIS_project AND folder_id = @SSIS_folder_ID
	IF @SSIS_project_ID IS NULL
	BEGIN
	  PRINT 'SSIS projekt findes ikke i aktuel folder i SSIS kataloget'
	  RETURN 0
	END

	IF NOT EXISTS (SELECT * FROM SSISDB.catalog.packages WHERE name = @SSIS_package AND project_id = @SSIS_project_ID)
	BEGIN
	  PRINT 'SSIS pakke findes ikke i aktuel projekt i SSIS kataloget'
	  RETURN 0
	END

	IF @SSIS_project  = 'BIMLBiz' -- retry på BIZ jobs
		SELECT @Retry = 2

	INSERT INTO dbo.SSIS_Job
	(
		SSIS_folder,
		SSIS_project,
		SSIS_package,
		Description,
		Notification,
		Notify,
		Retry,
		RepeatPeriod,
		isEnabled,
		OnHold
	)
	VALUES
	(   @SSIS_folder,			-- DHUB-PreProd, DIBA-PreProd eller KUPO-PreProd      SSIS_folder - nvarchar(50)   
		@SSIS_project,		-- SSIS_project - nvarchar(100)
		@SSIS_package,	-- SSIS_package - nvarchar(100)
			N'Under oprettelse',	-- Description - nvarchar(200)
			N'on error',			-- Notification - nvarchar(200)
			N'dwh@sydbank.dk',		-- Notify - nvarchar(200)
			@Retry,					-- Retry - nvarchar(200)
			0,					-- RepeatPeriod - nvarchar(200)
			0,						-- isEnabled - bit -------- Rettes efterfølgende når opsætning er færdig
			0						-- OnHold - bit
		)
	SELECT * FROM dbo.SSIS_Job WHERE SSIS_Job_ID = @@IDENTITY
--	SELECT @@IDENTITY AS SSIS_Job_ID
END
GO
/****** Object:  StoredProcedure [flju].[SSIS_JobDisable]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian P. Broe Petersen>
-- Create date: <2019-12-17>
-- Description:	<Disabler job, men kræver bemærkning, så man ved, hvorfor jobbet er disablet>
-- =============================================
CREATE PROCEDURE [flju].[SSIS_JobDisable]
    @SSIS_Job_ID INT,
    @Bemaerkning NVARCHAR(400)
AS
BEGIN
    DECLARE @Job_ID INT;

    SELECT @Job_ID = jd.SSIS_Job_ID
    FROM dbo.SSIS_Job_Dependencies jd
        INNER JOIN dbo.SSIS_Job j
            ON j.SSIS_Job_ID = jd.SSIS_Job_ID
    WHERE @SSIS_Job_ID = jd.DEP_SSIS_Job_ID
          AND j.isEnabled = 1;

    IF @Job_ID IS NOT NULL
    BEGIN
        SELECT 'PAKKEN KAN IKKE DISABLES DA DER ER AFHÆNGIGHEDER TIL DEN :' Advarsel,
               jd.SSIS_Job_ID,
               j.SSIS_package
        FROM dbo.SSIS_Job_Dependencies jd
            INNER JOIN dbo.SSIS_Job j
                ON j.SSIS_Job_ID = jd.SSIS_Job_ID
        WHERE @SSIS_Job_ID = jd.DEP_SSIS_Job_ID
              AND j.isEnabled = 1;
    END;
    ELSE
    BEGIN
        UPDATE dbo.SSIS_Job SET isEnabled = 0, Description = @Bemaerkning
        	WHERE SSIS_Job_ID = @SSIS_Job_ID
        SELECT *
        FROM dbo.SSIS_Job
        WHERE SSIS_Job_ID = @SSIS_Job_ID;
    END;
END;

GO
/****** Object:  StoredProcedure [flju].[SSIS_JobEnable]    Script Date: 16-10-2024 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [flju].[SSIS_JobEnable]
    @SSIS_Job_ID INT
AS
BEGIN
	UPDATE dbo.SSIS_Job SET Description = '', isEnabled = 1
		WHERE SSIS_Job_ID = @SSIS_Job_ID
	SELECT * FROM dbo.SSIS_Job WHERE SSIS_Job_ID = @SSIS_Job_ID
END
GO
