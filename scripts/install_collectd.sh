#!/bin/bash

# Installation script for Collectd
sudo yum install -y collectd collectd-rrdtool rrdtool collectd-web httpd

# HERE DOCUMENT
<<COMMENTS
Configuring collectd (leave all defaults):
 /etc/collectd.conf
 BaseDir "/var/lib/collectd"
 LoadPlugin rrdtool
 <Plugig rrdtool>
   DataDir "/var/lib/collectd/rrd"
   CreateFilesAsync false
   CacheTimeout 120
   CacheFlush 900
   WritesPerSecond 50
 </Plugin>

Configuring Apache (2.4)
 To list compiled Apache modules: httpd -l
 Eg. core.c, prefork.c, http_core.c and mod_so.c
 Add mod_authz_core by modifying httpd.conf:
 
 /etc/httpd/conf/httpd.conf
 listen 0.0.0.0:80  # Listen on IPv4 port 80
 /etc/httpd/conf.d/collectd.conf 
 Under Directory for collect3->mod_authz_core.c:
  Require ip <InsertPublicIp>
 
Configure hostname resolve (if not using DNS):
 /etc/hosts
 a.b.c.d <LocalHostName>
COMMENTS

# systemd which is NOT part of Linux AMI)
# Enable services at startup 
#sudo systemctl enable httpd
#sudo systemctl enable collectd
# Start services
#sudo systemctl start httpd
#sudo systemctl start collectd

# SysV/Upstart
# Enable services at startup
sudo chkconfig httpd on
sudo chkconfig collectd on
# Start services
sudo service httpd start
sudo service collectd start
