import random
import socket
import time
import json
from datetime import datetime, timezone

LOGSTASH_HOST = 'localhost'
LOGSTASH_PORT = 5044  # Default Logstash Beats input port

# Generate 20 random IP addresses
source_ips = [f"192.168.1.{i}" for i in range(1, 21)]

# Example event template
def generate_event():
    event = {
        "@timestamp": datetime.now(timezone.utc).isoformat(),
        "event_type": "sim_traffic",
        "src_ip": random.choice(source_ips),
        "dst_ip": f"10.0.0.{random.randint(1, 254)}",
        "user": random.choice(["alice", "bob", "carol", "dave"]),
        "action": random.choice(["login", "logout", "download", "upload"]),
        "status": random.choice(["success", "failure"]),
        "bytes": random.randint(100, 10000)
    }
    return event

def main():
    while True:
        event = generate_event()
        message = json.dumps(event) + "\n"
        try:
            # Connect to Logstash TCP input
            with socket.create_connection((LOGSTASH_HOST, LOGSTASH_PORT)) as sock:
                sock.sendall(message.encode('utf-8'))
                print(f"Sent event: {event}")
        except Exception as e:
            print(f"Error sending event: {e}")
        time.sleep(0.5)  # Adjust rate as needed

if __name__ == "__main__":
    main()
