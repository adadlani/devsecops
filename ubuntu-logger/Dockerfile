# This Dockerfile sets up an Ubuntu container with Filebeat installed.
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y wget gnupg rsyslog

# Install the correct version of Filebeat
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN sh -c 'echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list'
RUN apt-get update && apt-get install -y filebeat=8.11.3

# Comment out the kernel log module in rsyslog's config to prevent errors
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

# Copy our pre-configured filebeat.yml into the container
COPY filebeat.yml /etc/filebeat/filebeat.yml

# Simple script to generate logs continuously
RUN echo -e '#!/bin/bash\nwhile true; do echo "Ubuntu log entry: $(date)" | logger; sleep 10; done' > /usr/local/bin/generate_logs.sh && \
    chmod +x /usr/local/bin/generate_logs.sh

# Start the rsyslog daemon, then filebeat, and the log generator
CMD rsyslogd && filebeat -e & /usr/local/bin/generate_logs.sh
