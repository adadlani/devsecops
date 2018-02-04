#!/bin/bash -a
# Script to insall Apache Webserver on a CentOS 7x
# And configure instance to send web log to Splunk
# Logged in as user centos which is on sudo-ers list
# Assumes EC2 instance is an appropriate IAM role to access S3 bucket

# Update system
sudo yum update -y

# Dev environment cfgs
# Enable bash completion
complete -c systemctl
#complete -p # List current completions

# Install Apache
sudo yum install httpd

# Enable auto start
sudo systemctl enable httpd

# TODO: Install & Configure UF
./splunk_uf_install.sh 

# Add ACL rules for Splunk to access Apache logs
# TODO: To persist logrotate:
# https://serverfault.com/questions/258827/what-is-the-most-secure-way-to-allow-a-user-read-access-to-a-log-file
sudo setfacl -m g:splunk:rx /var/log/httpd
sudo setfacl -m g:splunk:rx /var/log/httpd/access_log
sudo setfacl -m g:splunk:rx /var/log/httpd/error_log

# Update Splunk inputs.conf
/opt/splunkforwarder/bin/splunk add monitor /var/log/httpd/access_log
/opt/splunkforwarder/bin/splunk add monitor /var/log/httpd/error_log

# Update Splunk outputs.conf
/opt/splunkforwarder/bin/splunk add forward-server $SPLUNK_SERVER:$SPLUNK_FWD_PORT

# Start httpd
sudo systemctl start httpd
