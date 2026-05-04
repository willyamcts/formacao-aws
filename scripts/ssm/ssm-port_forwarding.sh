HOST_BASTION="i-0140262f25477f754"
HOST_TO_CONNECT=bia-aurora.cluster-cqzmsio0yzwj.us-east-1.rds.amazonaws.com

echo aws ssm start-session --target $HOST_BASTION \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters '{"host":["'$HOST_TO_CONNECT'"],"portNumber":["5432"],"localPortNumber":["5432"]}'
