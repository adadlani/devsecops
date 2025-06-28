#!/bin/bash
# Script to create an instance

# Arguments:
#  -- ami_id AMI ID (default to the latest CentOS7?)
#
# Requirements:
#  - Must execute on a host with AWS CLI installed and configured
#
# Notes:
#  - aws ec2 describe-images --owners self amazon
#  - aws --region us-east-1 ec2 describe-images --owners aws-marketplace \
#    --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce 

AMI_ID=ami-02e98f78
KEY_PAIR=GDITKeyPair2
SG_GROUP=default
INSTANCE_TYPE=t2.micro

# EC2-VPC
# If you don't specify a subnet ID, we choose a default sub-
# net from your default VPC for you. If you don't have a  default  VPC,
# you must specify a subnet ID in the request.

# EC2-Classic
# If  don't  specify an Availability Zone, we choose one for you

INSTANCE_ID=`aws ec2 run-instances --image-id $AMI_ID --count 1 \
 --instance-type $INSTANCE_TYPE --key-name $KEY_PAIR --security-groups $SG_GROUP`

echo New instance created: $INSTANCE_ID
