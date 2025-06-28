#!/bin/bash
# Script to execute on a fresh install of CentOS 7.x to:
#  Perform system update
#  Install-Enable EPEL repository (e.g. awscli, collectd)
#  Install packages:
#   GIT
#   AWSCLI (via pip)
#   wget
#  Configure GIT
#  Clone repo
#  Configure AWS CLI for ease of use
# Typically user gets the file using curl:
# curl -O https://raw.githubusercontent.com/adadlani/devsecops/master/scripts/centos_initial_install.sh \
# --silent
# Assumptions:
#  - Executing as user centos which can execute sudo and $HOME set to /home/centos
#  - EC2 member of IAM role so we can execute AWS CLI
# Required arguments:
#  GH_USER username
#  GH_REPO repo (e.g. myrepo.git)
#  GH_CFG_NAME fullname (e.g. John Doe)
#  GH_CFG_EMAIL email (e.g. JohnDoe@JD.COM)

# Display help if 4 arguments not passed
if [[ $# -ne 4 ]] ; then
  echo Usage:
  echo    script GH_USER GH_REPO GH_CFG_NAME GH_CFG_EMAIL
  exit 1
fi

# Defaults
AWS_REGION=us-east-1
AWS_OUTPUT_FORMAT=json

# Update system
sudo yum update -y

# Install EPEL
yum -y install epel-release

# Install GIT
echo Installing GIT...
sudo yum install git -y

# Install AWSCLI (yum or pip?  AWS prefers pip)
echo Installing AWSCLI...
#sudo yum install awscli

# Store all our custom downloads to ~/download directory
mkdir $HOME/download

# PIP install
cd $HOME/download
curl -O https://bootstrap.pypa.io/get-pip.py --silent
python get-pip.py --user  # Installs pip in ~/.local/bin which is by default in $PATH

# AWSCLI install via PIP and configure
pip install awscli --upgrade --user
pip install jmespath-terminal --user
aws configure set region $AWS_REGION
aws configure set output $AWS_OUTPUT_FORMAT
complete -C aws_completer aws

# Install wget
echo Installing wget...
sudo yum install wget -y

# Configure GIT (HTTPS protocol assumed)
echo Configuring GIT...
git config --global push.default simple
git config --global credential.helper 'cache --timeout 7200'
git config --global user.name "$3"
git config --global user.email $4

echo Cloning repo...
cd $HOME
git clone https://github.com/$1/$2

# Following requires an existing repo (e.g. .git/config)
echo Configuring GITHub credentials....
cd ${2%.*}  # Get repo base name from $2
git config credentials.helper store
git push https://github.com/$1/$2 --all
