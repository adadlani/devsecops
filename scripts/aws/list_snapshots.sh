#!/bin/bash
# Script to list all available snapshots for an instance
# Arguments:
#  --id InstanceID (default to the latest instance launched in AWS account)
#
# Requirements:
#  If running in the instance then it must be part of an IAM role member

INSTANCE_ID=$1

# Get following of instance: 
#  EBS ID (e.g. vol-1234)

# On available snapshots, check all snapshots with the matching EBS-ID (e.g. vol-1234)

