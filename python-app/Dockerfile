FROM python:3.9-slim

# Install Filebeat
RUN apt-get update && apt-get install -y wget gnupg
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN sh -c 'echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list'
RUN apt-get update && apt-get install -y filebeat=8.11.3

# Set up the application
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
COPY filebeat.yml /etc/filebeat/filebeat.yml

# Create the log file and set permissions
RUN touch /var/log/app.log && chmod 666 /var/log/app.log

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Use the entrypoint script to start the services
ENTRYPOINT ["/app/entrypoint.sh"]