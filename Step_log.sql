USE [Token]
GO

/****** Object:  StoredProcedure [dbo].[Step_log]    Script Date: 5/17/2018 10:32:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Step_log] @STEPID_Proc int, @JOBID_Proc uniqueidentifier as

declare @Stepname nvarchar(255)

select @Stepname = (select step_name from msdb.dbo.sysjobsteps
where @STEPID_Proc = step_id and @JOBID_Proc = job_id)

IF EXISTS (select stepname from Log_DB.dbo.Steps where stepname = @Stepname)

BEGIN 
SET @Stepname = @Stepname
END

ELSE 
BEGIN
INSERT into Log_DB.DBO.STEPS 
select
@STEPID_Proc, 
Convert(char(255), @JOBID_Proc), 
convert(char(8), dateadd(second, last_run_duration, ''), 114),
NULL,
step_name
from msdb.dbo.sysjobsteps
where job_id = @JOBID_Proc
AND step_id = @STEPID_Proc
END

INSERT INTO Log_DB.dbo.STEPS_LOG
select 
@STEPID_Proc, 
convert(char(8), dateadd(second, last_run_duration, ''), 114),
convert(datetime, 
convert(char(8), last_run_date) + ' ' + convert(char(10),LEFT(last_run_time,2) + ':' + LEFT(RIGHT(last_run_time,4),2) + ':' + RIGHT(last_run_time,2)),
114),
convert(datetime, 
convert(char(8), last_run_date) + ' ' + convert(char(10),LEFT(last_run_time,2) + ':' + LEFT(RIGHT(last_run_time,4),2) + ':' + RIGHT(last_run_time + last_run_duration,2)),
114),
0,
last_run_outcome
from msdb.dbo.sysjobsteps
where last_run_time <> 0 AND step_id = @STEPID_Proc and job_id = @JOBID_Proc
GO


