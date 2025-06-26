# This Dockerfile sets up an Ubuntu container with Filebeat installed.
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y wget gnupg rsyslog auditd audispd-plugins sudo openssh-server

# Install the correct version of Filebeat
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN sh -c 'echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list'
RUN apt-get update && apt-get install -y filebeat=8.11.3

# Comment out the kernel log module in rsyslog's config to prevent errors
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

# Copy our pre-configured filebeat.yml into the container
COPY filebeat.yml /etc/filebeat/filebeat.yml

# Copy log generator scripts
COPY generate_logs.sh /usr/local/bin/generate_logs.sh
COPY generate_pki_logs.sh /usr/local/bin/generate_pki_logs.sh
RUN chmod +x /usr/local/bin/generate_logs.sh /usr/local/bin/generate_pki_logs.sh

# Set up SSH server (create run directory and set root password)
RUN mkdir /var/run/sshd && echo 'root:root' | chpasswd

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
