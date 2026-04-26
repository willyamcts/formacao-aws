#!/bin/bash

INSTANCE_ID="${1:-i-05e6517e24b3a78d7}"
PROFILE=lambda_user

aws ec2 describe-instances \
  --profile "$PROFILE" \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text


aws lambda invoke \
  --profile "$PROFILE" \
  --function-name bastion-ip-public-GetBastionIPFunction-tHSIt48GO9pV \
  --payload "{\"instance_id\": \"${INSTANCE_ID}\"}" \
  --cli-binary-format raw-in-base64-out \
  --output text /tmp/addr.txt > /dev/null

echo "Host to connect: $(cat /tmp/addr.txt) ..."
