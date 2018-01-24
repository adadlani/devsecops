#!/bin/bash -a
# Script to insall Splunk Server on a CentOS 7x 
# Logged in as user centos which is on sudo-ers list
# Assumes EC2 instance is an appropriate IAM role to access S3 bucket
# Required arguments:
#  BUCKET Contains the Splunk installation RPM

# Display help if required argument(s) not passed
if [[ $# -ne 1 ]] ; then
  echo Usage:
  echo    script BUCKET
  exit 1
fi

BUCKET=$1
LATEST_SPLUNK_RPM=splunk-7.0.1-2b5b15c4ee89-linux-2.6-x86_64.rpm

# Update system
sudo yum update -y

# Download latest Slunk
aws s3 cp s3://$BUCKET/$LATEST_SPLUNK_RPM $HOME/download

# Install Splunk
# Note error: useradd: cannot create directory /opt/splunk
# but installation seems to continue OK and /opt/splunk is created
# and newly created user splunk has owner-ship
sudo rpm -ivh $HOME/$LATEST_SPLUNK_RPM

# Setup env
export SPLUNK_HOME=/opt/splunk
export PATH=$SPLUNK_HOME/bin:$PATH

# Start Splunk (Since this is the first time we have to accept license)
# and ensure we run it under splunk user context
sudo -u splunk $SPLUNK_HOME/bin/splunk start --accept-license
# Result:
# The Splunk web interface is at http://internal-hostname:8000

# Auto start on reboots
sudo $SPLUNK_HOME/bin/splunk enable boot-start -user splunk
# Results:
#Init script installed at /etc/init.d/splunk.
#Init script is configured to run at boot.

# Other usefull CLIs
#splunk stop
#splunk restart
#splunk status

# Systemd
#sudo systemctl list-unit-files # List all unit files
#sudo systemctl enable|disable|start|stop <unit>

# Create certs to use for HTTPS
# Logic will need to be moved up eventually
# Create secret key file (key) and certificate signing request (csr) file
PUBLIC_DNS=$(curl http://169.254.169.254/latest/meta-data/public-hostname --silent)
openssl req -new -newkey rsa:2048 -nodes -keyout idx_web.key -out idx_web.csr\
 -sha256 -subj "/C=US/ST=VA/L=Sterling/O=Anel Dadlani/OU=Splunk TLS/CN=$PUBLIC_DNS"
# Create pem file by self-signing the csr file
openssl x509 -signkey idx_web.key -in idx_web.csr -req -sha256 -days 365 -out idx_web.pem
# TODO: Move the files in the desired locations

# We have *.key, *.csr and *.pem (Splunk uses *.key and *.pem) with web interface
# Create $SPLUNK_HOME/etc/system/local/web.conf with content
#[settings]
#enableSplunkWebSSL = true
#privKeyPath = etc/auth/idx_web/idx_web.key

# Restart Splunk
#serverCert = etc/auth/idx_web/idx_web.pem
