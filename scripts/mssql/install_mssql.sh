#!/bin/bash
# Script to install MS-SQL on Linux (RHEL 7.3+)

# Update system
sudo yum update

# Add repository
sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo

# Install SQL (Database engine)
# Default destinations:
#  /opt/mssql (Progam binaries & libraries)
#  /var/opt/mssql (Databases and log files, log directory and mssql.conf)
sudo yum install mssql-server

# Initial setup
# sudo /opt/msql/bin/mssql-conf setup
