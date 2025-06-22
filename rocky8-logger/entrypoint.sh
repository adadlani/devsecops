#!/bin/bash

# Start rsyslog service in non-daemon mode and send to background
rsyslogd -n &

# Start the log generator in the background
/usr/local/bin/generate_logs.sh &

# Start filebeat in the foreground. This becomes the main process.
exec filebeat -e