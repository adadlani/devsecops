#!/bin/bash

# Start filebeat in the background
filebeat -e &

# Start Flask in the foreground, redirecting its stdout and stderr to a log file
# This ensures that Filebeat can read the logs from a stable file source
exec flask run --host=0.0.0.0 >> /var/log/app.log 2>&1