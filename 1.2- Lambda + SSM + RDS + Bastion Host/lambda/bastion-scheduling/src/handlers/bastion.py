import boto3
import os

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    instance_id = event.get("instance_id") or os.getenv("INSTANCE_ID")
    action = event.get("action")

    if action not in ["start", "stop"]:
        raise ValueError("Parâmetros inválidos")

    print(f"{action} -> {instance_id}")

    if action == "start":
        ec2.start_instances(InstanceIds=[instance_id])
    else:
        ec2.stop_instances(InstanceIds=[instance_id])

    return {
        "action": action,
        "instance_id": instance_id,
        "status": "ok"
    }