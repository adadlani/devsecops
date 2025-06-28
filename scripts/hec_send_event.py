#!/bin/env python
# Sample script to send event over Splunk HTTP Collector (HEC)

# Typical JSON event structure:
"""
{
  "time": 1234567,
  "host": "myhost",
  "source": "datasource",
  "index": "main",
  "event": { "Hello, world!",
}
"""

import requests
import time
import uuid

data = {
    "event": "Hello world"
    # default values are used for:
    #   host: splunk server (receivers hostname)
    #   index: main
    #   source: http:PythonTest (name given on HEC UI)
    #   sourcetype: httpevent
}

url = 'https://fqn:8088/services'
send_url = url + '/collector'
status_url = url + '/collector/ack'
token = ''
headers = {
    'Authorization': 'Splunk ' + token,
    # send channel if indexer ack enabled
    'X-Splunk-Request-Channel': str(uuid.uuid1())
}

response = requests.post(send_url, json=data, verify=False, headers=headers)
print(response)
print(response.text)

# Check status if indexer ack enabled
time.sleep(5)
data = {
   "acks": [0,1,2,3,4] 
}
#response = requests.post(status_url, json=data, verify=False, headers=headers)
#print(response)
#print(response.text)
