# Environment settings

:white_check_mark: Docker (CLI only)
:white_check_mark: Git
:white_check_mark: VS Code
:white_check_mark: DBeaver
:white_check_mark: Kiro CLI
:white_check_mark: AWS CLI
:white_check_mark: AWS SAM CLI
:white_check_mark: Node.js v21


[Guide of settings here](https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/ENVIRONMENT.md)



# Challenges

## Challenge 4

Objective:
Create a script to launch a bastion host to connect to production resources. Perform remote port mapping on the local machine through the bastion host.

<img alt="challenge1-basic_environment" src="https://raw.githubusercontent.com/willyamcts/formacao-aws/refs/heads/0-fundamentals/diagrams/4-Bastion_tunnel+EC2+Docker+ECS+RDS+S3+ECR.drawio.png" />



## Challenge 3

Objective:
Run the BIA application on ECS (cluster with only one instance); assets should be delivered from the S3 bucket.

<img alt="challenge1-basic_environment" src="https://raw.githubusercontent.com/willyamcts/formacao-aws/refs/heads/0-fundamentals/diagrams/3-EC2+Docker+ECS+RDS+S3+ECR.drawio.png" />


Instructions to assets in S3 bucket ([docs.aws/AmazonS3/HostingWebsiteOnS3Setup](https://docs.aws.amazon.com/AmazonS3/latest/userguide/HostingWebsiteOnS3Setup.html#step2-create-bucket-config-as-website))...
```
# build project to send S3 bucket
docker cp bia:/usr/src/app/client/build .
#VITE_API_URL=http://localhost:3001 npm run build

# send dir to S3
aws s3 sync ./build s3://bia-fundamentals

# In AWS S3 > select bucket > Properties > "Bucket website endpoint" (last item of page)
```



## Challenge 1

Objective:
Prepare basic environment to start.

<img alt="basic_environment" src="https://raw.githubusercontent.com/willyamcts/formacao-aws/refs/heads/0-fundamentals/diagrams/1-EC2+Docker+BIA_app.drawio.png" />

