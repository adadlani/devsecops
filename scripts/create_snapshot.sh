#!/bin/bash
# Script to create a snapshot of an instance
# Can the instance be running?
# Can we execute this script on the running instance?
# Arguments:
#  --id InstanceID (default to the latest instance launched in AWS account)
#
# Requirements:
#  If running in the instance then it must be part of an IAM role member
