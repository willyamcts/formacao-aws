# Environment settings

:white_check_mark: Docker (CLI only)
:white_check_mark: Git
:white_check_mark: VS Code
:white_check_mark: DBeaver
:white_check_mark: Kiro CLI
:white_check_mark: AWS CLI
:white_check_mark: AWS SAM CLI
:white_check_mark: Node.js v21


- [Environment settings in Wiki page](https://github.com/willyamcts/formacao-aws/wiki)



# Challenges

* [**0.1.1 - EC2 + Docker + BIA App**](https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/1-EC2%2BDocker%2BBIA_app.drawio.png): prepare basic environment to start.
* [**0.1.3 - EC2 + Docker + ECS + RDS + S3**](https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/3-EC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png): run the BIA application on ECS (cluster with only one instance); assets should be delivered from the S3 bucket.
* [**0.1.4 - Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR**](https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/4-Bastion_tunnel%2BEC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png): create a script to launch a bastion host to connect to production resources. Perform remote port mapping on the local machine through the bastion host.
* **0.2.1 - Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR**: automate build new image for each modification from repository files. After build, the push to ECR with commit hash and update ECS cluster running to update with new image.
* **0.2.2 - ECS + ALB + CloudFront + Route53 + CodePipeline + ECR**: automate deploy CI/CD in ECS using GitHub repository - use CodeBuild and CodeDeploy.
* [**1.1 - EC2 + Docker + MSSQL + RDS + S3**](https://github.com/willyamcts/formacao-aws/blob/labs/diagrams/1.1-%20EC2%20%2B%20Docker%20%2B%20MSSQL%20%2B%20RDS%20%2B%20S3.png): migrating a database from an on-premises/EC2 environment to Amazon RDS and then from RDS back to on-premises using Docker.
