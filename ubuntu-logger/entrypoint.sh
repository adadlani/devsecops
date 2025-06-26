#!/bin/bash
rsyslogd
filebeat -e &
/usr/local/bin/generate_logs.sh &
/usr/local/bin/generate_pki_logs.sh &
wait