#!/bin/bash
# Script to restart Apache and Collectd

sudo systemctl stop collectd
sudo systemctl stop httpd
sudo systemctl start httpd
sudo systemctl start collectd
