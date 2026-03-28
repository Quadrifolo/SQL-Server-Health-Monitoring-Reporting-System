USE msdb;
GO

EXEC sp_add_job
    @job_name = N'Daily SQL Health Report';
GO

EXEC sp_add_jobstep
    @job_name = N'Daily SQL Health Report',
    @step_name = N'Run Health Report',
    @subsystem = N'TSQL',
    @database_name = N'YourDatabaseName',
    @command = N'EXEC dbo.usp_SendDatabaseHealthReport;';
GO

EXEC sp_add_schedule
    @schedule_name = N'Daily Schedule',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 060000;
GO

EXEC sp_attach_schedule
    @job_name = N'Daily SQL Health Report',
    @schedule_name = N'Daily Schedule';
GO

EXEC sp_add_jobserver
    @job_name = N'Daily SQL Health Report';
GO
