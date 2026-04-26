import boto3, os

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    instance_id = event.get("instance_id")
    if not instance_id:
        return {"error": "instance_id is required"}
    
    r = ec2.describe_instances(InstanceIds=[instance_id])
    ip = r['Reservations'][0]['Instances'][0].get('PublicIpAddress')
    return ip