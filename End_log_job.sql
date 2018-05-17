USE [Token]
GO

/****** Object:  StoredProcedure [dbo].[End_log_job]    Script Date: 5/17/2018 10:30:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[End_log_job] @JOBID_Proc uniqueidentifier as 

UPDATE  Log_DB.dbo.JOBS_LOG
set END_DATE = getdate()
where ID_JOB = @JOBID_Proc and END_DATE is null
GO


