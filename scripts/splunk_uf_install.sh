#!/bin/bash -a
# Script to insall Splunk Universal Forwarder on a CentOS 7x 
# Logged in as user centos which is on sudo-ers list
# Assumes EC2 instance is an appropriate IAM role to access S3 bucket
# Required arguments:
#  BUCKET Contains the Splunk UF installation RPM

# Display help if required argument(s) not passed
if [[ $# -ne 1 ]] ; then
  echo Usage:
  echo    script BUCKET
  exit 1
fi

BUCKET=$1
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

# Start
sudo -u splunk /opt/splunkforwarder/bin/splunk start

# Configure
#/opt/splunkforwarder/bin/splunk login -auth admin:changeme
#/opt/splunkforwarder/bin/splunk edit user admin -password NEW_PASSWORD
# Below probably need root priv.
#/opt/splunkforwarder/bin/splunk enable boot-start

##########################################################
# Modify /opt/splunkforwarder/etc/system/local/inputs.conf
#[default]
#host = fqn.of.current.host

# We can have multiple of these sections
#[monitor:///path/to/file]
#sourcetype = some_source_type
#disabled = 0
#index = linux_test2
##########################################################

##########################################################
# Create /opt/splunkforwarder/etc/system/local/outputs.conf
#[tcpout]
#defaultGroup = default-autolb-group

#[tcpout:default-autolb-group]
#server = fqn.to.splunk.server:9997

#[tcpout-server://fqn.to.splunk.server:9997]

##########################################################

# Restart splunk forwarder

# Confirm its sending data
#/opt/splunkforwarder/bin/splunk list forward-server
