# This Dockerfile sets up an AlmaLinux container with Filebeat installed.
FROM almalinux:9

# Install necessary packages, including procps-ng for debugging
RUN dnf install -y wget rsyslog procps-ng

# Install the correct version of Filebeat
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN cat <<EOF > /etc/yum.repos.d/elastic.repo
[elastic-8.11.3]
name=Elastic repository for 8.11.3 packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
RUN dnf install -y filebeat-8.11.3

# Create a simple, explicit rsyslog configuration
RUN cat <<EOF > /etc/rsyslog.conf
# rsyslog configuration file for Docker container
\$ModLoad imuxsock
\$InputUnixSocketSocket /dev/log
\$WorkDirectory /var/lib/rsyslog
\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
*.* /var/log/messages
EOF

# Copy our pre-configured filebeat.yml into the container
COPY filebeat.yml /etc/filebeat/filebeat.yml
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Simple script to generate logs continuously
RUN printf '#!/bin/bash\nwhile true; do echo "AlmaLinux log entry: $(date)" | logger; sleep 10; done' > /usr/local/bin/generate_logs.sh && \
    chmod +x /usr/local/bin/generate_logs.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script to start the services
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]