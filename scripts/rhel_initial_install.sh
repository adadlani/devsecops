#!/bin/bash
# Script to execute on a fresh install of RHEL 7.x
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

GH_USER=$1
GH_REPO=$2
GH_CFG_NAME=$3
GH_CFG_EMAIL=$4
echo $GH_USER
echo $GH_REPO
echo $GH_CFG_NAME
echo $GH_CFG_EMAIL

# Update system
sudo yum update -y

# Install GIT and configure (HTTPS protocol assumed)
sudo yum install git
GH_USER=$1
GH_REPO=$2
echo Configuring GITHub...
git config --global push.default simple
git config credentials.helper store
#git push https://github.com/$GH_USER/$GH_REPO
git config --global credential.helper 'cache --timeout 7200'
git config --global user.name "$3"
git config --global user.email $4
