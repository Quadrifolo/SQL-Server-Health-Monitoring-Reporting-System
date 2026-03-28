CREATE OR ALTER PROCEDURE dbo.usp_SendDatabaseHealthReport
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Html NVARCHAR(MAX) = N'';
    DECLARE @Subject NVARCHAR(200) = 'SQL Server Health Report - ' + @@SERVERNAME;

    /* ================= INDEX FRAGMENTATION ================= */
    DECLARE @FragTable NVARCHAR(MAX);

    SELECT @FragTable =
    (
        SELECT
            OBJECT_NAME(ps.object_id) AS td,
            i.name AS td,
            ps.avg_fragmentation_in_percent AS td,
            ps.page_count AS td
        FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ps
        INNER JOIN sys.indexes i
            ON ps.object_id = i.object_id
           AND ps.index_id = i.index_id
        WHERE ps.page_count > 100
        FOR XML PATH('tr'), ELEMENTS
    );

    SET @Html += '<h2>Index Fragmentation</h2><table border="1">
    <tr><th>Table</th><th>Index</th><th>Frag %</th><th>Pages</th></tr>'
    + ISNULL(@FragTable,'') + '</table>';

    /* ================= FILE SPACE ================= */
    DECLARE @FileTable NVARCHAR(MAX);

    SELECT @FileTable =
    (
        SELECT
            name AS td,
            size/128.0 AS td,
            CAST(FILEPROPERTY(name,'SpaceUsed') AS INT)/128.0 AS td
        FROM sys.database_files
        FOR XML PATH('tr'), ELEMENTS
    );

    SET @Html += '<h2>File Space</h2><table border="1">
    <tr><th>File</th><th>Total MB</th><th>Used MB</th></tr>'
    + ISNULL(@FileTable,'') + '</table>';

    /* ================= LONG RUNNING ================= */
    DECLARE @QueryTable NVARCHAR(MAX);

    SELECT @QueryTable =
    (
        SELECT
            r.session_id AS td,
            r.total_elapsed_time/1000.0 AS td,
            SUBSTRING(t.text,1,200) AS td
        FROM sys.dm_exec_requests r
        CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
        WHERE r.database_id = DB_ID()
        FOR XML PATH('tr'), ELEMENTS
    );

    SET @Html += '<h2>Long Running Queries</h2><table border="1">
    <tr><th>Session</th><th>Seconds</th><th>Query</th></tr>'
    + ISNULL(@QueryTable,'') + '</table>';

    /* ================= SEND EMAIL ================= */
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'SQLAlertsProfile',
        @recipients = 'your@email.com',
        @subject = @Subject,
        @body = @Html,
        @body_format = 'HTML';

END;
GO
