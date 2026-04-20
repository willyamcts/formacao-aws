##
# User data para Debian

TMP_FILE=/tmp/install.log
. /etc/os-release


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
wget "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip"
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"

sudo apt update
sudo apt install -y telnet netcat-openbsd iproute2
sudo apt install -y git jq unzip
sudo apt install -y ca-certificates curl


unzip awscliv2.zip
sudo ./aws/install
aws --version && \
  echo "AWS CLI Installed" >> $TMP_FILE || echo "AWS CLI FAIL" >> $TMP_FILE


unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
sam --version && \
  echo "AWS SAM CLI Installed" >> $TMP_FILE || echo "AWS SAM CLI FAIL" >> $TMP_FILE


sudo dpkg -i session-manager-plugin.deb
aws ssm --version && \
  echo "AWS SAM Pugin Installed" >> $TMP_FILE || echo "AWS SAM Plugin FAIL" >> $TMP_FILE



sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/${ID}/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/${ID}
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


sudo usermod -a -G docker admin
sudo usermod -a -G docker ssm-user
newgrp docker
