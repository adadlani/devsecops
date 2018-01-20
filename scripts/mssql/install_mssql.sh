#!/bin/bash
# Script to install MS-SQL on Linux (RHEL 7.3+)

# Update system
sudo yum update -y

# Add repositories
# mssql-server
sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo

# List all mssql packages:
sudo yum search mssql
# mssql-server.x86_64 : Microsoft SQL Server Relational Database Engine
# mssql-server-agent.x86_64 : Microsoft SQL Server Agent
# mssql-server-fts.x86_64 : Microsoft SQL Server Full Text Search
# mssql-server-ha.x86_64 : High Availability support for Microsoft SQL Server
#                       : Relational Database Engine
# mssql-server-is.x86_64 : Microsoft SQL Server Integration Services

# Client tools
sudo curl -o /etc/yum.repos.d/ms-prod.repo https://packages.microsoft.com/config/rhel/7/prod.repo

# Install SQL (Database engine), agent and client tools
# Default destinations:
#  /opt/mssql (Progam binaries & libraries)
#  /var/opt/mssql (Databases and log files, log directory and mssql.conf)
sudo yum install mssql-server mssql-server-agent mssql-tools -y

# Initial setup
# sudo /opt/msql/bin/mssql-conf setup
