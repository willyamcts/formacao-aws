#!/bin/bash

# Author: Willyam Castro
#
# Description: deploy EC2 instances with user interaction
#
# REQUIRED:
#   * IAM Policy: AWSResourceGroupsReadOnlyAccess
#


## Functions

check_exist_instance() {
    local name_instance=$1
    local instances=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${name_instance}" --query 'Reservations[].Instances[].[InstanceId,State.Name]' --output text)

    echo "$instances"
}


clear; echo
## Definitions
instance_type="t3.micro" && \
  echo "Instance type: t3.micro (free tier)"

region="us-east-1" && \
  echo "Region: us-east-1"


## User entry
read -p "Is test [y/N]? " is_test
read -p "Entry EC2 name: " name_instance
read -p "Entry AMI ID (ami-0f3caa1cf4417e51b - Amazon 2023 x64 us-east-1): " ami_id

if [ -z "$ami_id" ]; then
    ami_id="ami-0f3caa1cf4417e51b"
fi


# check if instance $name_instance not exist in EC2 instances
instance_exist=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${name_instance}" --query 'Reservations[].Instances[].[InstanceId,State.Name]' --output text)
#instance_exist=$(check_exist_instance $name_instance)

if [ ! -z "$instance_exist" ]; then
    echo
    echo "Instance $name_instance already exist"

    read -p "Do you wish to continue [y/N]? " ans
    case $ans in
        y|Y ) echo "Continuing...";;
        * ) echo "Abort."; exit 1;;
    esac
fi


echo
# how to list subnets and securitygroups availables
aws ec2 describe-subnets --query 'Subnets[*].[SubnetId,AvailabilityZone,CidrBlock]' --output table
read -p "Entry Subnet ID: " subnet_id

aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId,GroupName]' --output table
read -p "Entry Security Group: " secgroup_id


cat <<EOF > tags.json
[
  {
    "ResourceType": "instance",
    "Tags": [
      {
        "Key": "Name",
        "Value": "${name_instance}"
      }
    ]
  }
]
EOF

case $is_test in
    [y|Y])
    aws ec2 run-instances --image-id ${ami_id} --count 1 --dry-run \
  --region ${region} \
  --subnet-id ${subnet_id} \
  --security-group-ids ${secgroup_id} \
  --tag-specifications file://tags.json \
  --instance-type ${instance_type} \
  --user-data file://data/user_data_ec2_zona_a.sh
        ;;
    * )
    aws ec2 run-instances --image-id ${ami_id} --count 1 \
  --region ${region} \
  --subnet-id ${subnet_id} \
  --security-group-ids ${secgroup_id} \
  --tag-specifications file://tags.json \
  --instance-type ${instance_type} \
  --user-data file://data/user_data_ec2_zona_a.sh
        ;;
esac

# what command aws cli to deploy EC2 instance t3.micro in us-east-1


rm tags.json
