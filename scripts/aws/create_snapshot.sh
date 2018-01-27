#!/bin/bash
# Script to create a snapshot of an instance
# Can the instance be running?
# Can we execute this script on the running instance?
# Arguments:
#  --id InstanceID (default to the latest instance launched in AWS account)
#
# Requirements:
#  If running in the instance then it must be part of an IAM role member

INSTANCE_ID=$1

# Get following of instance: 
#  Root device (e.g. /dev/sda1)
ROOT_DEVICE=$(curl http://169.254.169.254/latest/meta-data/block-device-mapping/ami --silent)
#  Block devices (e.g. /dev/sda1)
BLOCK_DEVICE=$(curl http://169.254.169.254/latest/meta-data/block-device-mapping/ami --silent)
#  EBS ID (e.g. vol-1234)

# Create snapshot of EBS ID
# Assign:  Name and Descriptiona
# Returns: SnapShotID

# Wait till snapshot completes (takes a few minutes)
