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



### Challenge Labs

| N. | Diagram | Description / Objective |
|---------|-------|-------|
| 1 | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/labs/diagrams/1.1-%20EC2%20%2B%20Docker%20%2B%20MSSQL%20%2B%20RDS%20%2B%20S3.png" alt="image" /> | **EC2 + Docker + MSSQL + RDS + S3** </br> </br> Migrating a database from an on-premises/EC2 environment to Amazon RDS and then from RDS back to on-premises using Docker. |


### Preparatories

| N. | Diagram | Description / Objective |
|---------|-------|-------|
| 1 | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/" alt="image" /> | **Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR** </br> </br> Automate build new image for each modification from repository files. After build, the push to ECR with commit hash and update ECS cluster running to update with new image. |
| 2 | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/" alt="image" /> | **ECS + ALB + CloudFront + Route53 + CodePipeline + ECR** </br> </br> Automate deploy CI/CD in ECS using GitHub repository - use CodeBuild and CodeDeploy. |



###  Fundamentals

| N. | Diagram | Description / Objective |
|---------|-------|-------|
| 1 | <img align="left" width="50%" src="https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/1-EC2%2BDocker%2BBIA_app.drawio.png" alt="image" /> | **EC2 + Docker + BIA App** </br> </br> Basic environment settings to start. |
| 3 | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/3-EC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png" alt="image" /> | **EC2 + Docker + ECS + RDS + S3** </br> </br> Run the BIA application on ECS (cluster with only one instance); assets should be delivered from the S3 bucket. |
| 4 | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/4-Bastion_tunnel%2BEC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png" alt="image" /> | **Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR**  </br> </br> Create a script to launch a bastion host to connect to production resources. Perform remote port mapping on the local machine through the bastion host. |


