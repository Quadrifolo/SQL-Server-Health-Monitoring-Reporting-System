SELECT
    session_id,
    blocking_session_id,
    wait_type
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
