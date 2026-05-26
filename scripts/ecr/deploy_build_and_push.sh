#!/bin/bash

# Author: Willyam Castro
##
# Description: build docker image and send to Amazon ECR
#
# REQUIRED:
#  * ECR repository
##

DIR_BIA=$HOME/bia
ECR_URI=$1
ECR_FQND=$(echo ${ECR_URI} | awk -F'/' '{print $1}')
REPOSITORY_NAME=$(echo ${ECR_URI} | cut -d'/' -f2-)
#IP_API=$(grep -Po '\d+\.\d+\.\d+\.\d+' ${DIR_BIA}/Dockerfile)
IP_API=$(grep -oE 'https?://[^ ]+' ${DIR_BIA}/Dockerfile |cut -d'/' -f3 | cut -d'.' -f1)
IMAGE_NAME_LOCAL="${REPOSITORY_NAME}:${IP_API}-$(date +%d%m%y_%H%M)"
IMAGE_NAME_REMOTE=$IMAGE_NAME_LOCAL


[[ -z $ECR_URI ]] && \
  echo "Uso: $0 <REPOSITORY URI>" && \
  exit 1

echo "
 - URI: $ECR_URI
 - Repository FQDN: $ECR_FQND
 - Repository name: $REPOSITORY_NAME
 - IP/FQDN: $IP_API
"


cd $DIR_BIA
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_FQND
docker build -t "${IMAGE_NAME_LOCAL}" .
docker tag ${IMAGE_NAME_LOCAL} $ECR_FQND/${IMAGE_NAME_REMOTE}
docker push $ECR_FQND/${IMAGE_NAME_REMOTE}
