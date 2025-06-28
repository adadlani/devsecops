#!/bin/env python
# Sample script to get weater and send to Splunk HEC

import os
import requests
import uuid

def send_event(event):
    host = os.environ['SPLUNK_SERVER']
    url = 'https://' + host + ':8088/services'
    send_url = url + '/collector'
    status_url = url + '/collector/ack'
    hec_token = os.environ['HEC_KEY']
    headers = {
        'Authorization': 'Splunk ' + hec_token
        # send channel if indexer ack enabled
        #'X-Splunk-Request-Channel': str(uuid.uuid1())
    }
    # Update event with some additional information
    event['host'] = os.environ['HOSTNAME']
    try:
        response = requests.post(send_url, json=event, verify=False, headers=headers)
        print(response)
        print(response.text)
    except Exception as e:
        print("Splunk Request failed!")
        print(e)
  

base = 'https://api.openweathermap.org'
api_key = os.environ['API_KEY']
end_point = base + '/data/2.5/weather'
pay_load = {
    'APPID': api_key,
    'zip': 20165,
    'units': 'imperial'
}
response = requests.get(end_point, params=pay_load)
if response.status_code == 200:
    data = response.json()
    # Construct event to send to Splunk
    event = { "event": {}}
    if 'main' in data and 'temp' in data['main']:
       event['event'].update({'temp': data['main']['temp']})
    if 'wind' in data:
       if 'speed' in data['wind']:
           event['event'].update({'wind_speed': data['wind']['speed']})
       if 'deg' in data['wind']:
           event['event'].update({'wind_deg': data['wind']['deg']}) 
    send_event(event)
