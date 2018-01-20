#!/bin/bash
# Script to insall Docker on a CentOS 7x (Docker CE)
# Logged in as user centos which is on sudo-ers list
# Update system
sudo yum update -y

# Simplest method:
wget -qO- https://get.docker.com/ | sh

#If you would like to use Docker as a non-root user, you should now consider
#adding your user to the "docker" group with something like:
#
#  sudo usermod -aG docker centos
#
#Remember that you will have to log out and back in for this to take effect!
#
#WARNING: Adding a user to the "docker" group will grant the ability to run
#         containers which can be used to obtain root privileges on the
#         docker host.
#         Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
#         for more information.
sudo usermod -aG docker centos

# LOGOUT & LOGIN

# Start docker and enable at startup
sudo systemctl start docker
sudo systemctl enable docker

# Few useful Docker cmds:
# docker version
# docker info
