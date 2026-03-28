SELECT
    session_id,
    total_elapsed_time/1000.0 AS Seconds,
    status
FROM sys.dm_exec_requests
WHERE session_id <> @@SPID
ORDER BY total_elapsed_time DESC;
