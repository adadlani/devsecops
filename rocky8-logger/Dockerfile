# This Dockerfile sets up a Rocky Linux 8 container with Filebeat installed.
FROM rockylinux:8
RUN dnf install -y wget rsyslog procps-ng
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
RUN cat <<EOF > /etc/rsyslog.conf
\$ModLoad imuxsock
\$InputUnixSocketSocket /dev/log
\$WorkDirectory /var/lib/rsyslog
\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
*.* /var/log/messages
EOF
COPY filebeat.yml /etc/filebeat/filebeat.yml
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN printf '#!/bin/bash\nwhile true; do echo "Rocky 8 log entry: $(date)" | logger; sleep 10; done' > /usr/local/bin/generate_logs.sh && \
    chmod +x /usr/local/bin/generate_logs.sh && \
    chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]