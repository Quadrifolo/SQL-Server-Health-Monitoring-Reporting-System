# SQL Server Health Monitoring & Reporting System

## Overview
Automated SQL Server monitoring solution that runs daily and sends HTML reports via Database Mail.

## Features
- Index fragmentation monitoring
- File space tracking
- Long-running query detection
- Blocking session visibility
- Automated email reporting

## Architecture
- Stored procedure generates report
- SQL Agent schedules execution
- Database Mail sends email

## Setup
1. Enable Database Mail
2. Configure mail profile
3. Deploy stored procedure
4. Create SQL Agent job

## Usage
```sql
EXEC dbo.usp_SendDatabaseHealthReport;
