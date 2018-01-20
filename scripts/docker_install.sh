#!/bin/bash
# Script to insall Docker on a CentOS 7x (Docker CE)

# Update system
sudo yum update -y

# Simplest method:
sudo wget -qO- https://get.docker.com/ | sh
