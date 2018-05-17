USE [Token]
GO

/****** Object:  StoredProcedure [dbo].[Start_log_job]    Script Date: 5/17/2018 10:33:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Start_log_job]

@Job_ID_Proc uniqueidentifier as
DECLARE @Jobname nvarchar(255)

set @Jobname = (select [name] from msdb.dbo.sysjobs
where @Job_ID_Proc = job_id)

IF EXISTS (select job_name from Log_DB.dbo.JOBS where job_name = @Jobname)

BEGIN 
SET @Jobname = @Jobname
END

ELSE 
BEGIN
INSERT into Log_DB.DBO.JOBS 
select
@Job_ID_Proc,
ssj.stepid,
convert(datetime, convert(char(8), next_run_date)) + ' ' + convert(char(10),LEFT(next_run_time,2) + ':' + LEFT(RIGHT(next_run_time,4),2) + ':' + RIGHT(next_run_time,2),114),
NULL, 
convert(char(8), dateadd(second, sj.last_run_duration, ''), 114),
NULL,
@Jobname
from msdb.dbo.sysjobservers sj 
join (select max(step_id)as stepid,job_id from msdb.dbo.sysjobsteps where job_id = @Job_ID_Proc group by job_id) ssj on sj.job_id = ssj.job_id
left join msdb.DBO.sysjobschedules sjs on sj.job_id = sjs.job_id
where sj.job_id = @Job_ID_Proc
END

INSERT INTO Log_DB.dbo.JOBS_LOG
select 
@Job_ID_Proc, 
convert(char(8), dateadd(second, sj.last_run_duration, ''), 114),
NULL,
NULL,
sj.last_run_outcome,
ssj.stepid,
convert(datetime, convert(char(8), sj.last_run_date)) + ' ' + convert(char(10),LEFT(sj.last_run_time,2) + ':' + LEFT(RIGHT(sj.last_run_time,4),2) + ':' + RIGHT(sj.last_run_time,2),114),
null
from msdb.dbo.sysjobservers sj
join (select max(step_id)as stepid,job_id from msdb.dbo.sysjobsteps where job_id = @Job_ID_Proc group by job_id) ssj on sj.job_id = ssj.job_id
where sj.job_id = @Job_ID_Proc
GO


