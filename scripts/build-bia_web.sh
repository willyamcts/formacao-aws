#!/bin/bash

# Author: Willyam Castro
##
# Description: build application files and create compose with web
#   application only. Destined to EC2 instance when database in
#   Amazon RDS
##

DIR_ROOT=$HOME/formacao-aws
API_IP="${1}"
DB_FQDN="${2}"
WEB_PORT_EXTERNAL=80

clear
[[ -z $1 || -z $2 ]] && \
  echo "usage: $0 <API public IP> <FQDN Database>" && \
  exit 1


echo "Entry password from database:"
read -p passwd


cat > compose.yml.AWS << EOF
services:
  server:
    build: .
    container_name: bia
    ports:
      - ${WEB_PORT_EXTERNAL}:8080
    depends_on:
      - database
    environment:
      DB_USER: postgres
      DB_PWD: ${passwd}
      DB_HOST: ${DB_FQDN}
      DB_PORT: 5432
EOF




cd $DIR_ROOT/bia/client

VITE_API_URL=http://${1} npm run build


#sed -i "s#RUN cd client && VITE_API_URL.*#RUN cd client && VITE_API_URL=http://$1 npm run build#" ${DIR_ROOT}/bia/Dockerfile
