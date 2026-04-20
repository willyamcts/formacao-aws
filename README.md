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

* [0.1.1 - EC2 + Docker + BIA App](https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/1-EC2%2BDocker%2BBIA_app.drawio.png)
* [0.1.3 - EC2 + Docker + ECS + RDS](https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/3-EC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png)
* [0.1.4 - Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR](https://github.com/willyamcts/formacao-aws/blob/0-fundamentals/diagrams/4-Bastion_tunnel%2BEC2%2BDocker%2BECS%2BRDS%2BS3%2BECR.drawio.png)
* 0.2.1 - Bastion Host + ECS + EC2 + Docker + RDS + S3 + ECR: automate build new image for each modification from repository files. After build, the push to ECR with commit hash and update ECS cluster running to update with new image.
* 0.2.2 - ECS + ALB + CloudFront + Route53 + CodePipeline + ECR
