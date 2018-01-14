#!/bin/bash
# Script to execute on a fresh install of RHEL 7.x to:
#  Perform system update
#  Enable rhui-REGION-rhel-server-optional repository (e.g. awscli)
#  Add EPEL repository (e.g collectd)
#  Install packages:
#   GIT
#   AWSCLI
#  Configure GIT
#  Clone repo
# Typically user gets the file using curl:
# curl https://raw.githubusercontent.com/adadlani/devsecops/master/scripts/rhel_initial_install.sh \
#  --output rhel_initial_install.sh --silent
# Assumes executing as ec2-user which can execute sudo
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

# Update system
sudo yum update -y

# Enable rhui-REGION-rhel-server-optional repo
# /etc/yum.repos.d/redhat-rhui.repo
sudo yum-config-manager --enable rhui-REGION-rhel-server-optional

# Install EPEL
curl https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --output epel-release-latest-7.noarch.rpm \
 --silent
sudo yum install epel-release-latest-7.noarch.rpm -y

# Install GIT
echo Installing GIT...
sudo yum install git -y

# Install AWSCLI (yum or pip?  AWS prefers pip)
echo Installing AWSCLI...
#sudo yum install awscli
curl -O https://bootstrap.pypa.io/get-pip.py --silent
python get-pip.py --user  # Installs pip in ~/.local/bin
# TODO: PATH must include ~/.local/bin (automagically done?)

# Configure GIT (HTTPS protocol assumed)
echo Configuring GIT...
git config --global push.default simple
git config --global credential.helper 'cache --timeout 7200'
git config --global user.name "$3"
git config --global user.email $4

echo Cloning repo...
git clone https://github.com/$1/$2

# Following requires an existing repo (e.g. .git/config)
echo Configuring GITHub credentials....
cd ${2%.*}  # Get rename name from $2
git config credentials.helper store
git push https://github.com/$1/$2 --all
