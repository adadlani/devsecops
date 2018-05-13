#!/bin/bash -a
# Script to insall NiFi on a CentOS 7x 
# Logged in as user centos which is on sudo-ers list
# Assumes EC2 instance is an appropriate IAM role to access S3 bucket
# Required arguments:
#  BUCKET Contains all tools/cfgs

# Display help if required argument(s) not passed
if [[ $# -ne 1 ]] ; then
  echo Usage:
  echo    script BUCKET
  exit 1
fi

BUCKET=$1

# Create folder to store all install/cfg files
mkdir $HOME/download

# Update system
sudo yum update -y

# Install wget
sudo yum install wget

# Install Java 1.8
sudo yum install java-1.8.0-openjdk

# Download latest Nifi
LATEST_NIFI_TAR=nifi-1.6.0-bin.tar.gz
aws s3 cp s3://$BUCKET/$LATEST_NIFI_TAR $HOME/download

# Unpack NiFi
tar -xvf $HOME/download/nifi-1.6.0-bin.tar.gz $HOME

# Setup env
export JAVA_HOME=/usr/lib/jvm/jre-openjdk

# Start NiFi

# Auto start on reboots


