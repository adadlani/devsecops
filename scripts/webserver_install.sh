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

# Start httpd
sudo systemctl start httpd
