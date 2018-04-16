CREATE TABLE [dbo].[JOBS](
	[ID_JOB] [nvarchar](255) NOT NULL,
	[COUNT_STEPS] [int] NULL,
	[SCHEDULE] [nvarchar](255) NULL,
	[DEPENDENCIES] [nvarchar](255) NULL,
	[AVG_DURATION_TIME] [time](7) NULL,
	[JOB_OWNER] [nvarchar](255) NULL,
	[JOB_NAME] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[JOBS_LOG](
	[ID_JOB] [nvarchar](255) NOT NULL,
	[DURATION_TIME] [time](7) NULL,
	[AUTHOR] [nvarchar](255) NULL,
	[NOTIFICATION] [bit] NULL,
	[STATUS] [nvarchar](255) NULL,
	[COUNT_STEPS] [int] NULL,
	[START_DATE] [datetime2](7) NULL,
	[END_DATE] [datetime2](7) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LOG_PROCEDURE](
	[ID_RUN] [int] IDENTITY(1,1) NOT NULL,
	[PROCEDURE_NAME] [nvarchar](50) NULL,
	[START_DATE] [datetime2](7) NULL,
	[END_DATE] [datetime2](7) NULL,
	[STATUS] [nvarchar](50) NULL,
	[CHECKPOINT] [nvarchar](50) NULL,
	[MESSAGE] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[STEPS](
	[ID_Step] [nvarchar](50) NOT NULL,
	[ID_Job] [nvarchar](50) NOT NULL,
	[Duration_Time] [time](7) NULL,
	[Dependencies] [nchar](10) NULL,
	[Stepname] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[STEPS_LOG](
	[ID_STEP] [nvarchar](50) NOT NULL,
	[Duration_Time] [time](7) NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[Notification] [bit] NULL,
	[Status] [nvarchar](50) NULL
) ON [PRIMARY]
GO



