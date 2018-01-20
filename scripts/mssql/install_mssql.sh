#!/bin/bash
# Script to install MS-SQL on Linux (RHEL 7.3+)

# Update system
sudo yum update -y

# Add repositories
# mssql-server
sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo

# INFO: List all mssql packages:
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

# Initial setup (accept license and enter SA password)
# sudo /opt/msql/bin/mssql-conf setup

# Punch holes in firewall
sudo firewall-cmd --add-port=1433/tcp --permanent
sudo firewall-cmd --reload

# INFO: Examine contents of pkgs and point out few files
# rpm -ql mssql-server
#  /opt/mssql/bin <-directory->
#  /opt/mssql/bin/sqlservr <-sql server binary->
#  /opt/mssql/bin/mssql-conf <-utility to configure sql->
#  /opt/mssql/lib/sqldkxplat.sfp & sqlservr.sfp <-pal components->
# rpm -ql mssql-server-agent
#  /opt/mssql/lib/sqlagent.sfp <-pal component additional functionality->
# rpm -ql mssql-tools
#  /opt/mssql-tools/bin/bcp <-utility for bulk loading->
#  /opt/mssql-tools/bin/sqlcmd <-sql cli->
# Other import paths/files:
# ls -1 /opt/mssql/bin
#  compress-dump.sh
#  crash-support-functions.sh
#  generate-sql-dump.sh
#  handle-crash.sh
#  mssql-conf
#  paldumper
#  sqlservr
# ls -1 /opt/mssql/lib
#  *.so
#  *.sfp
# ls -1 /var/opt/mssql/
#  ./data
#    master.mdf, masterlog.ldf
#    modellog.ldf, model.mdf
#    msdbdata.mdf,msdblog.ldf
#    tempdb.mdf,temlog.ldf
#  ./log
#  mssql.conf
#  ./secrets

# Update PATH so we can call sqlcmd
echo "PATH=$PATH:/opt/mssql-tools/bin" >> $HOME/.bash_profile
