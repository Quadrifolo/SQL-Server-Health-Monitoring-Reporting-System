-- Create Database Mail Account
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'SQLAlertsAccount',
    @description = 'SQL Server Health Alerts',
    @email_address = 'your@email.com',
    @display_name = 'SQL Server Alerts',
    @mailserver_name = 'smtp.yourserver.com';

-- Create Mail Profile
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'SQLAlertsProfile',
    @description = 'Profile for SQL Health Monitoring';

-- Link Account to Profile
EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'SQLAlertsProfile',
    @account_name = 'SQLAlertsAccount',
    @sequence_number = 1;

-- Grant access
EXEC msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'SQLAlertsProfile',
    @principal_id = 0,
    @is_default = 1;
