# Lambda Function

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


### Test local

See `scripts/bastion-get_ip.sh`


### Deploy

```bash
# first running
sam deploy --guided #--profile default

# next runnings
sam deploy #--profile default
```


### Remove function of Lambda

```bash
sam delete #--profile default
```
