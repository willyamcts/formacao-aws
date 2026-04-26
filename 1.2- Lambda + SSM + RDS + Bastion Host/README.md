# Lambda Functions

```mermaid
flowchart TD
    %% Actors and Triggers
    User((User))
    Cron([Amazon EventBridge\nCron: 07 AM & 06 PM])

    %% AWS Environment
    subgraph AWS [AWS Cloud - VPC]
        direction TB
        
        subgraph Automation
            LambdaCron[Lambda\nStart/Stop Bastion]
        end
        
        subgraph AccessManagement[Access Management]
            LambdaIP[Lambda\nget-bastion-ip]
        end

        Bastion[EC2 Instance\nBastion Host\nDynamic Public IP]
        RDS[(Amazon RDS\nPostgreSQL - Port 5432)]
    end

    %% Flow 1: Automation (Cron)
    Cron -- "Triggers function" --> LambdaCron
    LambdaCron -- "Start (7AM) / Stop (6PM)" --> Bastion

    %% Flow 2: IP Discovery
    User -- "Manual Execution\n(CLI / Script)" --> LambdaIP
    LambdaIP -- "Check state &\nReturn Public IP" --> Bastion
    Bastion -. "Returns IP" .-> LambdaIP
    LambdaIP -. "Delivers IP" .-> User
    
    %% Flow 3: Connection (Tunneling)
    User ==>|1. Open SSH Tunnel via IP| Bastion
    Bastion ==>|2. Forward Traffic| RDS

    %% Styles
    classDef aws fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:white;
    classDef db fill:#336791,stroke:#232F3E,stroke-width:2px,color:white;
    classDef user fill:#4285F4,stroke:#232F3E,stroke-width:2px,color:white;
    
    class LambdaCron,LambdaIP,Cron,Bastion aws;
    class RDS db;
    class User user;
```


Functions:

1. Scheduling start and stop instance.
2. Get IPv4 address of instances.



# Function: scheduling instance start/stop times

**Objective**: Leave instance enabled only during business hours.

* Function in the `lambda/bastion-scheduling` directory.


### Test local

The field `instance_id` of `echo` command, replace INSTANCE_ID from `template.yaml` file.

```bash
# start EC2 instance
echo '{"action":"start", "instance_id":"i-05e6517e24b3a78d7"}' | sam local invoke BastionSchedulerFunction  --event -

# stop EC2 instance
echo '{"action":"stop", "instance_id":"i-05e6517e24b3a78d7"}' | sam local invoke BastionSchedulerFunction  --event -
```

For fix instance ID, replace `INSTANCE_ID` in `template.yaml` file.






# Function: get IPv4 address of instances

**Objective**: To provide only public IPv4 addresses, not allowing EC2:DescribeInstance or the use of Elastic IP resource.

Developers who need the instance's public IPv4 address to connect. This lambda function only returns the IPv4 address (get), and does not allow any other execution. This is to avoid using Elastic IP or releasing the full listing of instances -- zero trust principle.


Created new profile `lambda_user` with policy attached:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetPublicIPInstance",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "arn:aws:lambda:us-east-1:117911340068:function:bastion-ip-public-*"
        }
    ]
}
```

Function in the `lambda/bastion-get_ipv4_public/` directory.


### Test local

See `scripts/bastion-get_ip.sh`



# Lambda -- build, deploy and delete

### Build and Deploy

```bash
# first running
sam build
sam deploy --guided #--profile default

# next runnings
sam build && \
sam deploy #--profile default
```


### Remove function of Lambda

```bash
sam delete #--profile default
```
