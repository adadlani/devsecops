#!/bin/bash
# Script to install Minikube using VirtualBox as Hypervisor

# Install VirtualBox
curl -O https://download.virtualbox.org/virtualbox/5.2.6/VirtualBox-5.2-5.2.6_120293_el7-1.x86_64.rpm

sudo rpm -ivh VirtualBox-5.2-5.2.6_120293_el7-1.x86_64.rpm
