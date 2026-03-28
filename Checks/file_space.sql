SELECT
    name,
    size/128.0 AS TotalMB,
    CAST(FILEPROPERTY(name,'SpaceUsed') AS INT)/128.0 AS UsedMB
FROM sys.database_files;
