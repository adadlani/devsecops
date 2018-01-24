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
sudo rpm -ivh $HOME/download/$LATEST_SPLUNK_RPM

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

#################################
# Create certs to use for HTTPS
#################################
# Logic will need to be moved up eventually
# Create secret key file (key) and certificate signing request (csr) file
PUBLIC_DNS=$(curl http://169.254.169.254/latest/meta-data/public-hostname --silent)
KEY_FILE=$SPLUNK_HOME/idx_web.key
CSR_FILE=$SPLUNK_HOME/idx_web.csr
PEM_FILE=$SPLUNK_HOME/idx_web.pem
SUBJECT="/C=US/ST=CA/L=San Francisco/O=Splunk Org/OU=Splunk Unit/CN=$PUBLIC_DNS"
sudo -u splunk openssl req -new -newkey rsa:2048 -nodes -keyout $KEY_FILE -out $CSR_FILE\
 -sha256 -subj $SUBJECT

# Create pem file by self-signing the csr file
sudo -u splunk openssl x509 -signkey $KEY_FILE -in $CSR_FILE -req -sha256 -days 365 -out $PEM_FILE

# TODO: Move the files in the desired locations
KEY_PATH=$SPLUNK_HOME/etc/auth/idx_web
sudo -u splunk mkdir $KEY_PATH
sudo -u splunk mv $KEY_FILE $KEY_PATH/.
sudo -u splunk mv $CSR_FILE $KEY_PATH/.
sudo -u splunk mv $PEM_FILE $KEY_PATH/.

# We have *.key, *.csr and *.pem (Splunk uses *.key and *.pem) with web interface
# Create $SPLUNK_HOME/etc/system/local/web.conf with content
cat<<EOF >>web.conf
[settings]
enableSplunkWebSSL = true
privKeyPath = etc/auth/idx_web/idx_web.key
serverCert = etc/auth/idx_web/idx_web.pem
EOF
sudo -u splunk mv web.conf $SPLUNK_HOME/etc/system/local

# Restart Splunk
sudo -u splunk $SPLUNK_HOME/bin/splunk restart
