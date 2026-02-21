# Current environment

:white_check_mark: Docker (CLI only)
:white_check_mark: Git
:white_check_mark: VS Code
:white_check_mark: DBeaver
:white_check_mark: Kiro CLI
:white_check_mark: AWS CLI
:white_check_mark: AWS SAM CLI
:white_check_mark: Node.js v21


<img width="731" height="632" alt="challenge1-basic_environment" src="https://github.com/user-attachments/assets/cc37f927-52b8-464d-bfc0-0ecd99cfec48" />




# Preparing the environment


### Host settings

```
# set keyboard layout PT-BR
setxkbmap br

# install RDP Server to remote access
sudo apt install -y xrdp

# some packages requeriments
sudo apt install -y unzip curl
```



### Git + VS Code + DBeaver (db client)

In VS Code, install extensions:
* GitHub Pull Request
* Amazon Q

```
sudo apt install -y git

wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/b6a47e94e326b5c209d118cf0f994d6065585705/code_1.109.3-1770920364_amd64.deb
sudo dpkg -i code_1.109.3-1770920364_amd64.deb


wget https://github.com/dbeaver/dbeaver/releases/download/25.3.4/dbeaver-ce_25.3.4_amd64.deb
sudo dpkg -i dbeaver-ce_25.3.4_amd64.deb

```



### Docker Engine

[Steps to install](https://docs.docker.com/engine/install/ubuntu/#os-requirements)

```
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Adding current user in docker group (after `sudo` not is required)

```
sudo groupadd docker
sudo usermod -aG docker $USER

# reload shell with new group
newgrp docker
```


### Clone henrylle/bia

```
git clone --depth 1 https://github.com/henrylle/bia
cd bia && hash=$(git rev-parse --short HEAD)
cd .. && mv bia bia@${hash}
```


### AWS CLI

Steps to install: [docs.aws.amazon.com/cli/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

```
cd ~/Downloads
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version && \
  echo "Install OK" || echo " *** FAIL ***"
```


### AWS SAM CLI

Steps to install: [docs.aws.amazon.com/install-sam-cli.html](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)

```
cd ~/Downloads
wget "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip"
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
sam --version && \
  echo "Install OK" || echo " *** FAIL ***"
```


### AWS SAM Plugin

Steps: [docs.aws.amazon.com/install-plugin-debian-and-ubuntu.html](https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-debian-and-ubuntu.html)

```
cd ~/Downloads
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
aws ssm --version && \
  echo "Install OK" || echo " *** FAIL ***"  
```


### Kiro CLI

Steps to install: [https://kiro.dev/docs/cli](https://kiro.dev/docs/cli)

```
# install
curl -fsSL https://cli.kiro.dev/install | bash

# add Kiro dir in $PATH
echo "PATH=$PATH:/home/$USER/.local/bin" >> ~/.bashrc

# reload terminal
. ~/.bashrc
```


### Node.js

Steps to install: [digitalocean.com/how-to-install-node-js-on-ubuntu-20-04](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04)

```
cd ~
curl -sL https://deb.nodesource.com/setup_21.x -o /tmp/nodesource_setup.sh
#nano /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install -y nodejs
echo "Node version: $(node -v)" && echo "NPM version: $(npm -v)" && \
  echo "Install OK" || echo " *** FAIL ***"
```



# Starting with BIA

Steps in [henrylle/bia](https://github.com/henrylle/bia)

```
cd bia
docker compose up -d && \
  ( docker compose exec server bash -c 'npx sequelize db:migrate' || "$(grep -E '^docker' README.md)" )

```



# Settings

### Connect AWS CLI

```
# set Access Key generated in IAM (with policy permissions: AmazonSSMFullAccess, AmazonEC2ContainerRegistryFullAccess)
aws configure
# or another profile...
aws configure --profile lab-fundamentals

# output:
AWS Access Key ID [None]: AKIARW5xxxxxxx
AWS Secret Access Key [None]: <......>
Default region name [None]: us-east-1
Default output format [None]: table


# test
aws ecr describe-repositories
```


### Connect EC2 via SSM

Script in [github.com/henrylle/bia/start-session-bash.sh](hhttps://github.com/henrylle/bia/blob/main/scripts/start-session-bash.sh)

```
aws ssm start-session --target <ID_EC2_INSTANCE>
```

