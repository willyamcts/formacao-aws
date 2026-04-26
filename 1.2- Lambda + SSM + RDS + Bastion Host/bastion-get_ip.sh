#!/bin/bash

INSTANCE_ID="${1:-i-05e6517e24b3a78d7}"
INSTANCE_DESTINATION="${2:-database-1.cqzmsio0yzwj.us-east-1.rds.amazonaws.com}"
PROFILE=lambda_user

aws lambda invoke \
  --profile "$PROFILE" \
  --function-name bastion-ip-public-GetBastionIPFunction-tHSIt48GO9pV \
  --payload "{\"instance_id\": \"${INSTANCE_ID}\"}" \
  --cli-binary-format raw-in-base64-out \
  --output text /tmp/addr.txt > /dev/null

echo "Bastion IP: $(cat /tmp/addr.txt)"



read -p "Do you want connect to RDS (localhost:5433) [Y/n]? " ans

if [[ "$ans" =~ ^[Yy] ]] || [[ -z $ans ]]; then
  aws ssm start-session \
    --target "$INSTANCE_ID" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters "{\"host\":[\"${INSTANCE_DESTINATION}\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"5433\"]}" && \
  echo "Connected ${INSTANCE_DESTINATION}:5432 -> localhost:5433"
fi
