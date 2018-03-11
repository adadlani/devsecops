# Script to create a JIRA ticket(s)
import json
import os
import requests
import sys

user = os.environ['JIRA_USER']
password = os.environ['JIRA_PWD']  
protocol = 'http:/'
host = '127.0.0.1'
port = ':8080/'
rest_base = 'rest/api/2'

g_project = None
g_issue_type = None
g_priority = None
g_labels = None
g_watchers = None
g_reporter = None
g_summary = None
g_description = None
g_assignee = None

class Ticket:
    def __init__(self, key=None, issue_type=None, reporter=None, priority=None,
                 label=None, watchers=None, summary=None, description=None, assignee=None):
        self.key = key
        self.issue_type = issue_type
        self.reporter = reporter
        self.priority = priority
        self.labels = label
        self.watchers = watchers
        self.summary = summary
        self.description = description
        self.assignee = assignee
    
    def __str__(self):
        return '//'.join([str(self.key), str(self.issue_type),
                          str(self.summary), str(self.description),
                          str(self.reporter), str(self.priority),
                          str(self.assignee)])
    
    def set(self, member, value):
        if member == 'summary':
            self.summary = value
        elif member == 'issue_type':
            self.issue_type = value
        elif member == 'key':
            self.key = value
        elif member == 'priority':
            self.priority = value
        elif member == 'labels':
            self.labels.append = value
        elif member == 'watchers':
            self.watchers.append = value
        elif member == 'assignee':
            self.assignee = value
        elif member == 'description':
            self.description = value


def create_ticket(ticket=None, parent_ticket_key=None):
    # Build REST endpoint
    createissue_api = 'issue/'
    end_point = '/'.join([protocol, host]) + port + '/'.join([rest_base, 
                          createissue_api])
    
    # Required fields
    post_data = {
        'fields': {
            'project': {'key': ticket.key},
            'issuetype': {'name': ticket.issue_type},
            'summary': ticket.summary,
            # Seems to auto-populate reporter but explicitly send
            'reporter': {'name': ticket.reporter}
        }
    }
    
    # Optional fields
    if ticket.description:    
        post_data['fields']['description'] = ticket.description
    if ticket.labels:
        post_data['fields']['labels'] = ticket.labels
    if ticket.assignee:
        post_data['fields']['assignee'] = {'name': ticket.assignee}

    # Set priority as it uses id
    if ticket.priority:
        if ticket.priority == 'Low':
            priority_id = '4'
        elif ticket.priority == 'Medium':
            priority_id = '3'
        else:
            priority_id = '2'
        post_data['fields']['priority'] = {'id': priority_id}

    # If this is a Sub-task then also pass a parent key
    if parent_ticket_key:
        post_data['fields']['parent']= {'id': parent_ticket_key}

    # Send the request
    r = requests.post(end_point, auth=(user, password), json=post_data)
    if r.status_code <= 201:
        return r.status_code, r.json()['key']
    else:
        print(r.text)
        return None


def add_watchers(ticket, ticket_key):
    # Build REST endpoint
    end_point = '/'.join([protocol, host]) + port + '/'.join([rest_base, 
                         'issue', ticket_key, 'watchers'])
    
    # Add wachers
    for watcher in ticket.watchers:
        # Send the request
        r = requests.post(end_point, auth=(user, password), json=watcher)
        print('Add watcher', watcher, 'status:', r.status_code)


def set_global_fields(cfg_data):
    if 'project' in cfg_data:
        global g_project
        g_project = cfg_data['project']  # Required
    if 'issue_type' in cfg_data:
        global g_issue_type
        g_issue_type = cfg_data['issue_type']  # Required
    if 'summary' in cfg_data:
        global g_summary
        g_sumamry= cfg_data['summary']  # Required
    if 'priority' in cfg_data:
        global g_priority
        g_priority = cfg_data['priority']
    if 'labels' in cfg_data:
        global g_labels
        g_labels = cfg_data['labels']
    if 'watchers' in cfg_data:
        global g_watchers
        g_watchers = cfg_data['watchers']
    if 'reporter' in cfg_data:
        global g_reporter
        g_reporter= cfg_data['reporter']
    if 'description' in cfg_data:
        global g_description
        g_description= cfg_data['description']
    if 'assignee' in cfg_data:
        global g_assignee
        g_assignee = cfg_data['assignee']


def set_override_fields(t, ticket):
    if 'issuetype' in ticket:
        t.set('issue_type', ticket['issuetype'])
    if 'summary' in ticket:
        t.set('summary', ticket['summary'])
    if 'priority' in ticket:
        t.set('priority', ticket['priority'])
    if 'labels' in ticket:
        t.set('labels', ticket['labels'])
    if 'watchers' in ticket:
        t.set('watchers', ticket['watchers'])
    if 'description' in ticket:
        t.set('description', ticket['description'])

# Read a file with configuration and create tickets
cfg_data = json.load(open('./ticket_cfg.json'))

# Set global field values
set_global_fields(cfg_data)

# Iter through the list of tickets and apply any over-rides
for ticket in cfg_data['tickets']:
    # Create base ticket
    t = Ticket(key=g_project, issue_type=g_issue_type, reporter=g_reporter,
               priority=g_priority, label=g_labels, watchers=g_watchers,
               summary=g_summary, description=g_description, assignee=g_assignee)
    
    # Set overrides
    set_override_fields(t, ticket)

    # Create ticket    
    if t.issue_type == 'Task':
        print('Generating Task...', end='')
        status, parent_ticket_key = create_ticket(t)
        print('status:', status, parent_ticket_key)
        if parent_ticket_key and t.watchers:
            add_watchers(t, parent_ticket_key)
    else:
        print('Generating Sub-task...', end='')
        status, ticket_key = create_ticket(t, parent_ticket_key)
        print('status:', status, ticket_key)
        if ticket_key and t.watchers:
            add_watchers(t, ticket_key)

    
