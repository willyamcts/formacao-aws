# What can you find in this repository?

* Files related to practices performed in an AWS environment
* [Environment settings in Wiki page](https://github.com/willyamcts/formacao-aws/wiki)



# Summary of hands-on

| N. | Diagram | Description / Objective |
|---------|-------|-------|
| [1](https://github.com/willyamcts/training-aws/tree/labs/1.1-%20EC2%20%2B%20Docker%20%2B%20MSSQL%20%2B%20RDS%20%2B%20S3) | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/labs/diagrams/1.1-%20EC2%20%2B%20Docker%20%2B%20MSSQL%20%2B%20RDS%20%2B%20S3.png" alt="image" /> | **EC2 + Docker + MSSQL + RDS + S3** </br> </br> Migrating a database from an on-premises/EC2 environment to Amazon RDS and then from RDS back to on-premises using Docker. |
| [2](https://github.com/willyamcts/training-aws/tree/labs/1.2-%20Lambda%20%2B%20SSM%20%2B%20RDS%20%2B%20Bastion%20Host) | <img align="left" width="80%" src="https://github.com/willyamcts/training-aws/blob/labs/diagrams/1.2-%20EC2%20+%20Lambda%20+%20RDS%20+%20Bastion%20Host.png" alt="image" /> | **EC2 + Lambda + RDS + Bastion Host** </br> </br> Create two Lambda functions: one to schedule the startup and shutdown of the bastion host, and another to obtain the public IP address of the bastion host (without using Elastic IPs or the EC2:DescribeInstance policy for the user). Using a bash script, retrieve the IP address of the bastion instance via the Lambda function and connect to RDS through a port tunnel. |
| [3](https://github.com/willyamcts/training-aws/tree/labs/1.3-%20RDS%20%2B%20Clone%20%2B%20RPIT%20(Restore%20to%20Point%20in%20Time)) | <img align="left" width="80%" src="https://github.com/willyamcts/training-aws/blob/labs/diagrams/1.2-%20EC2%20+%20Lambda%20+%20RDS%20+%20Bastion%20Host.png" alt="image" /> | **EC2 + Lambda + RDS + Bastion Host** </br> </br> Create two Lambda functions: one to schedule the startup and shutdown of the bastion host, and another to obtain the public IP address of the bastion host (without using Elastic IPs or the EC2:DescribeInstance policy for the user). Using a bash script, retrieve the IP address of the bastion instance via the Lambda function and connect to RDS through a port tunnel. |




### Preparatories

| N. | Diagram | Description / Objective |
|---------|-------|-------|
| [1](https://github.com/willyamcts/training-aws/tree/1-preparatory) | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/" alt="image" /> | **Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR** </br> </br> Automate build new image for each modification from repository files. After build, the push to ECR with commit hash and update ECS cluster running to update with new image. |
| [2](https://github.com/willyamcts/training-aws/tree/1-preparatory) | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/" alt="image" /> | **ECS + ALB + CloudFront + Route53 + CodePipeline + ECR** </br> </br> Automate deploy CI/CD in ECS using GitHub repository - use CodeBuild and CodeDeploy. |



###  Fundamentals

| N. | Diagram | Description / Objective |
|---------|-------|-------|
| [1](https://github.com/willyamcts/training-aws/tree/0-fundamentals) | <img align="left" width="50%" src="https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/1-EC2%2BDocker%2BBIA_app.drawio.png" alt="image" /> | **EC2 + Docker + BIA App** </br> </br> Basic environment settings to start. |
| [2](https://github.com/willyamcts/training-aws/tree/0-fundamentals) |  | **EC2 + Docker + BIA App + SSM + SSH** </br> </br> Launch an instance EC2 with BIA App and create a connection SSM and SSH. After build image Docker and send image to ECR. |
| [3](https://github.com/willyamcts/training-aws/tree/0-fundamentals) | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/3-EC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png" alt="image" /> | **EC2 + Docker + ECS + RDS + S3** </br> </br> Run the BIA application on ECS (cluster with only one instance); assets should be delivered from the S3 bucket. |
| [4](https://github.com/willyamcts/training-aws/tree/0-fundamentals) | <img align="left" width="80%" src="https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/4-Bastion_tunnel%2BEC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png" alt="image" /> | **Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR**  </br> </br> Create a script to launch a bastion host to connect to production resources. Perform remote port mapping on the local machine through the bastion host. |


