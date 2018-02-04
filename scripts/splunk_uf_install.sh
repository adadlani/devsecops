#!/bin/bash -a
# Script to insall Splunk Universal Forwarder on a CentOS 7x 
# Logged in as user centos which is on sudo-ers list
# Assumes EC2 instance is an appropriate IAM role to access S3 bucket
# Required arguments:
#  BUCKET Contains the Splunk UF installation RPM
#  New password for Splunk UF
#  Index name
#  Splunk server to send messages

# Display help if required argument(s) not passed
if [[ $# -ne 4 ]] ; then
  echo Usage:
  echo    script BUCKET NEW_PASSWORD INDEX_NAME SPLUNK_SERVER
  exit 1
fi

BUCKET=$1
NEW_PASSWORD=$2
INDEX_NAME=$3
SPLUNK_SERVER=$4

LATEST_SPLUNK_UF_RPM=splunkforwarder-7.0.1-2b5b15c4ee89-linux-2.6-x86_64.rpm

# Update system
sudo yum update -y

# Download latest Slunk
aws s3 cp s3://$BUCKET/$LATEST_SPLUNK_UF_RPM $HOME/download

# Install Splunk UF
# Note error: useradd: cannot create directory /opt/splunk
# but installation seems to continue OK and /opt/splunk is created
# and newly created user splunk has owner-ship
sudo rpm -ivh $HOME/download/$LATEST_SPLUNK_UF_RPM

# Default location of Splunk Forwarder
SPLUNK_UF_HOME=/opt/splunkforwarder
# Start
sudo -u splunk $SPLUNK_UF_HOME/bin/splunk start --accept-license

# Configure
sudo -u splunk $SPLUNK_UF_HOME/bin/splunk login -auth admin:changeme
sudo -u splunk $SPLUNK_UF_HOME/bin/splunk edit user admin -password $NEW_PASSWORD

# Need root priv.
sudo $SPLUNK_UF_HOME/bin/splunk enable boot-start -user splunk

##########################################################
# Create /opt/splunkforwarder/etc/system/local/inputs.conf
PUBLIC_DNS=$(curl http://169.254.169.254/latest/meta-data/public-hostname --silent)
cat<<EOF >> inputs.conf
[default]
host = $PUBLIC_DNS

[monitor:///var/log]
sourcetype = some_source_type
disabled = 0
index = $INDEX_NAME
EOF
sudo mv inputs.conf $SPLUNK_UF_HOME/etc/system/local
sudo chown splunk:splunk $SPLUNK_UF_HOME/etc/system/local/inputs.conf
##########################################################

##########################################################
# Create /opt/splunkforwarder/etc/system/local/outputs.conf
# Method 1:
#cat<<EOF >> outputs.conf
#[tcpout]
#defaultGroup = default-autolb-group
#
#[tcpout:default-autolb-group]
#server = $SPLUNK_SERVER:9997
#
#[tcpout-server://$SPLUNK_SERVER:9997]
#EOF
#sudo mv outputs.conf $SPLUNK_UF_HOME/etc/system/local
#sudo chown splunk:splunk $SPLUNK_UF_HOME/etc/system/local/outputs.conf
# Method 2:
sudo -u splunk $SPLUNK_UF_HOME/bin/splunk add forward-server $SPLUNK_SERVER:9997
##########################################################

# Restart splunk forwarder
sudo -u splunk $SPLUNK_UF_HOME/bin/splunk restart

# Confirm its sending data
sudo -u splunk $SPLUNK_UF_HOME/bin/splunk list forward-server
