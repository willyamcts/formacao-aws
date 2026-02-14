# Preparing the environment

:white_check_mark: Git 
:white_check_mark: VS Code
:white_check_mark: DBeaver
:white_check_mark: Kiro CLI

### Host settings

```
# set keyboard layout PT-BR
setxkbmap br
```

### Git + VS Code + DBeaver (db client) + xRDP (RDP Server)

In VS Code: install extension "GitHub Pull Request"


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


### Kiro-CLI

Steps: [https://kiro.dev/docs/cli](https://kiro.dev/docs/cli)

```
# install
curl -fsSL https://cli.kiro.dev/install | bash

# add Kiro dir in $PATH
echo "PATH=$PATH:/home/$USER/.local/bin" >> ~/.bashrc

# reload terminal
. ~/.bashrc
```


# Starting with BIA

Steps in [henrylle/bia](https://github.com/henrylle/bia)

```
cd bia
docker compose up -d && \
  ( docker compose exec server bash -c 'npx sequelize db:migrate' || "$(grep -E '^docker' README.md)" )

```
