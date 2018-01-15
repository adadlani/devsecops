#!/bin/bash
# Script to restore a snapshot for an instance
# Arguments:
#  --id InstanceID (default to the latest instance launched in AWS account)
#  --sid SnapshotID (snapshot ID to restore)
#
# Requirements:
#  If running in the instance then it must be part of an IAM role member

INSTANCE_ID=$1
SNAPSHOT_ID=$2
