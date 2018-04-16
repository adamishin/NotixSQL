USE [msdb]
GO

/****** Object:  Job [Log_step]    Script Date: 4/16/2018 1:29:05 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 4/16/2018 1:29:05 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Log_step', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'WIN-85PKJL5MJCQ\Adam', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Job_Log]    Script Date: 4/16/2018 1:29:05 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Job_Log', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'declare @JOBID uniqueidentifier
declare @Jobname nvarchar(255)

select @JOBID = $(ESCAPE_NONE(JOBID));
select @Jobname = (select [name] from msdb.dbo.sysjobs
where @JOBID = job_id)

IF EXISTS (select job_name from Log_DB.dbo.JOBS where job_name = @Jobname)

BEGIN 
SET @Jobname = @Jobname
END

ELSE 
BEGIN
INSERT into Log_DB.DBO.JOBS 
select
@JOBID,
ssj.stepid,
convert(datetime, convert(char(8), next_run_date)) + '' '' + convert(char(10),LEFT(next_run_time,2) + '':'' + LEFT(RIGHT(next_run_time,4),2) + '':'' + RIGHT(next_run_time,2),114),
NULL, 
convert(char(8), dateadd(second, sj.last_run_duration, ''''), 114),
NULL,
@Jobname
from msdb.dbo.sysjobservers sj 
join (select max(step_id)as stepid,job_id from msdb.dbo.sysjobsteps where job_id = @JOBID group by job_id) ssj on sj.job_id = ssj.job_id
left join msdb.DBO.sysjobschedules sjs on sj.job_id = sjs.job_id
where sj.job_id = @JOBID
END

INSERT INTO Log_DB.dbo.JOBS_LOG
select 
@JOBID, 
convert(char(8), dateadd(second, sj.last_run_duration, ''''), 114),
NULL,
NULL,
sj.last_run_outcome,
ssj.stepid,
convert(datetime, convert(char(8), sj.last_run_date)) + '' '' + convert(char(10),LEFT(sj.last_run_time,2) + '':'' + LEFT(RIGHT(sj.last_run_time,4),2) + '':'' + RIGHT(sj.last_run_time,2),114),
null
from msdb.dbo.sysjobservers sj
join (select max(step_id)as stepid,job_id from msdb.dbo.sysjobsteps where job_id = @JOBID group by job_id) ssj on sj.job_id = ssj.job_id
where sj.job_id = @JOBID', 
		@database_name=N'Log_DB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [StepLog]    Script Date: 4/16/2018 1:29:05 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'StepLog', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--declare @StepName nvarchar(50)
declare @STEPID int
declare @JOBID uniqueidentifier
declare @Stepname nvarchar(255)

--select @StepName = $(ESCAPE_NONE(STEPNAME));
select @STEPID = $(ESCAPE_NONE(STEPID));
select @JOBID = $(ESCAPE_NONE(JOBID));
select @Stepname = (select step_name from msdb.dbo.sysjobsteps
where @STEPID = step_id and @JOBID = job_id)

IF EXISTS (select stepname from Log_DB.dbo.Steps where stepname = @Stepname)

BEGIN 
SET @Stepname = @Stepname
END

ELSE 
BEGIN
INSERT into Log_DB.DBO.STEPS 
select
@STEPID, 
Convert(char(255), @JOBID), 
convert(char(8), dateadd(second, last_run_duration, ''''), 114),
NULL,
step_name
from msdb.dbo.sysjobsteps
where job_id = @JOBID
AND step_id = @STEPID
--Convert(char(255), @StepName)
END

INSERT INTO Log_DB.dbo.STEPS_LOG
select 
@STEPID, 
convert(char(8), dateadd(second, last_run_duration, ''''), 114),
convert(datetime, 
convert(char(8), last_run_date) + '' '' + convert(char(10),LEFT(last_run_time,2) + '':'' + LEFT(RIGHT(last_run_time,4),2) + '':'' + RIGHT(last_run_time,2)),
114),
convert(datetime, 
convert(char(8), last_run_date) + '' '' + convert(char(10),LEFT(last_run_time,2) + '':'' + LEFT(RIGHT(last_run_time,4),2) + '':'' + RIGHT(last_run_time + last_run_duration,2)),
114),
0,
last_run_outcome
from msdb.dbo.sysjobsteps
where last_run_time <> 0 AND step_id = @STEPID and job_id = @JOBID', 
		@database_name=N'Log_DB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [InsertData]    Script Date: 4/16/2018 1:29:05 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'InsertData', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--declare @StepName nvarchar(50)
declare @STEPID int
declare @JOBID uniqueidentifier
declare @Stepname nvarchar(255)

--select @StepName = $(ESCAPE_NONE(STEPNAME));
select @STEPID = $(ESCAPE_NONE(STEPID));
select @JOBID = $(ESCAPE_NONE(JOBID));
select @Stepname = (select step_name from msdb.dbo.sysjobsteps
where @STEPID = step_id and @JOBID = job_id)

IF EXISTS (select stepname from Log_DB.dbo.Steps where stepname = @Stepname)

BEGIN 
SET @Stepname = @Stepname
END

ELSE 
BEGIN
INSERT into Log_DB.DBO.STEPS 
select
@STEPID, 
Convert(char(255), @JOBID), 
convert(char(8), dateadd(second, last_run_duration, ''''), 114),
NULL,
step_name
from msdb.dbo.sysjobsteps
where job_id = @JOBID
AND step_id = @STEPID
--Convert(char(255), @StepName)
END

INSERT INTO Log_DB.dbo.STEPS_LOG
select 
@STEPID, 
convert(char(8), dateadd(second, last_run_duration, ''''), 114),
convert(datetime, 
convert(char(8), last_run_date) + '' '' + convert(char(10),LEFT(last_run_time,2) + '':'' + LEFT(RIGHT(last_run_time,4),2) + '':'' + RIGHT(last_run_time,2)),
114),
convert(datetime, 
convert(char(8), last_run_date) + '' '' + convert(char(10),LEFT(last_run_time,2) + '':'' + LEFT(RIGHT(last_run_time,4),2) + '':'' + RIGHT(last_run_time + last_run_duration,2)),
114),
0,
last_run_outcome
from msdb.dbo.sysjobsteps
where last_run_time <> 0 AND step_id = @STEPID and job_id = @JOBID

exec Token.dbo.Insertdata
', 
		@database_name=N'Log_DB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Job_log_End]    Script Date: 4/16/2018 1:29:05 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Job_log_End', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'declare @JOBID uniqueidentifier

select @JOBID = $(ESCAPE_NONE(JOBID));

UPDATE  Log_DB.dbo.JOBS_LOG
set END_DATE = getdate()
where ID_JOB = @JOBID and END_DATE is null
', 
		@database_name=N'Log_DB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


