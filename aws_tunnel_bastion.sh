#!/bin/bash

# Author: Willyam Castro
##
# Description: Create an SSM tunnel using an EC2 instance as a bridge
#   to reach endpoints. $1 = instance that will serve as the bridge
#   and $2 (if provided) = database URI.
##
INSTANCE_BRIDGE=$1
DNS_RDS=$2

clear; echo
if [[ -z "$INSTANCE_BRIDGE" || $INSTANCE_BRIDGE != i-* ]]; then
  echo "USAGE: $0 <EC2 INSTANCE BRIDGE ID> [DNS RDS]"
  echo
  aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value|[0],State.Name,InstanceId]' --output table
  exit 1
fi


# instance bridge name through of instance id
instance_bridge_name=$(aws ec2 describe-instances --filters "Name=instance-id, Values=${INSTANCE_BRIDGE}" --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value|[0]]' --output text)

# get status of instance bridge
instance_bridge_status=$(aws ec2 describe-instances --filters "Name=instance-id, Values=${INSTANCE_BRIDGE}" --query 'Reservations[].Instances[].[State.Name]' --output text)

if [[ "$instance_bridge_status" != "running" ]]; then
  read -p "Instance bridge is not running! You wish start instance [Y/n] " ans
  case $ans in
    n|N) exit 1;;
  esac

  # start instance bridge
  aws ec2 start-instances --instance-ids $INSTANCE_BRIDGE > /dev/null
fi


# list all instances EC2 with name, status and id
aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value|[0],State.Name,InstanceId]' --output table
read -p "Entry instance ID to connect (80:8080): " instance_id_to_connect

# get internal IP address
#aws ec2 describe-instances --filters "Name=instance-id, Values=${instance_id_to_connect}" --query 'Reservations[].Instances[].[PrivateIpAddress,InstanceId]' --output table
instance_ip_to_connect=$(aws ec2 describe-instances --filters "Name=instance-id, Values=${instance_id_to_connect}" --query 'Reservations[].Instances[].[PrivateIpAddress]' --output text)


echo "
Connections:
* Instance bridge to connectons: ${instance_bridge_name} (${INSTANCE_BRIDGE})
* Instance to connect: ${instance_id_to_connect} (${instance_ip_to_connect})
* DNS RDS: $DNS_RDS
"



echo "Initiating tunnel through \"${instance_bridge_name}\" (${INSTANCE_BRIDGE})"

# Connection to BIA-WEB by BIA-DEV (another region) SSM tunnel
 setsid aws ssm start-session --target "$INSTANCE_BRIDGE" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters '{"host":["'$instance_ip_to_connect'"],"portNumber":["80"],"localPortNumber":["8080"]}' \
    > ssm_tunnel_${instance_ip_to_connect}.log 2>&1 &

echo $! > /var/tmp/aws_tunnel_${instance_ip_to_connect}.pid
echo "  * Tunnel PID to ${instance_ip_to_connect}: $(cat /var/tmp/aws_tunnel_${instance_ip_to_connect}.pid) - LOG: ssm_tunnel_${instance_ip_to_connect}.log"



# Connection to RDS PostgreSQL by BIA-DEV (another region) SSM tunnel
if [[ ! -z "$DNS_RDS"  ]]; then
  setsid aws ssm start-session --target "$INSTANCE_BRIDGE" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters '{"host":["'$DNS_RDS'"],"portNumber":["5432"],"localPortNumber":["5433"]}' \
    > ssm_tunnel_rds.log 2>&1 &

  echo $! > /var/tmp/aws_ssm_rds_tunnel.pid
  echo "  * RDS Tunnel PID: $(cat /var/tmp/aws_ssm_rds_tunnel.pid) - LOG: ssm_tunnel_rds.log"
fi

echo "
To kill proccess run: 
  pkill -f \"session-manager-plugin\"
  pkill -f \"aws ssm\"
"
