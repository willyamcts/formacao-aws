#!/bin/bash

# Script Build and Deploy - Projeto BIA
# Automatiza: Build Docker -> Push ECR -> Deploy ECS
# Uso: ./build-and-deploy.sh <cluster> <service>

set -e

# Configurações
REGION="us-east-1"
ECR_REPO="fundamentals/bia"
TASK_FAMILY="bia-task-definition"

# Verificar parâmetros
if [ $# -ne 2 ]; then
    echo "=== Clusters ECS Disponíveis ==="
    CLUSTERS=$(aws ecs list-clusters --region $REGION --query 'clusterArns[*]' --output text | tr '\t' '\n' | awk -F'/' '{print $NF}')

    if [ -z "$CLUSTERS" ]; then
        echo "Nenhum cluster encontrado"
        exit 1
    fi

    echo "$CLUSTERS" | nl
    echo
    read -p "Selecione o número do cluster: " CLUSTER_NUM
    CLUSTER=$(echo "$CLUSTERS" | sed -n "${CLUSTER_NUM}p")

    if [ -z "$CLUSTER" ]; then
        echo "Seleção inválida"
        exit 1
    fi

    echo
    echo "=== Services no Cluster: $CLUSTER ==="
    SERVICES=$(aws ecs list-services --region $REGION --cluster $CLUSTER --query 'serviceArns[*]' --output text | tr '\t' '\n' | awk -F'/' '{print $NF}')

    if [ -z "$SERVICES" ]; then
        echo "Nenhum service encontrado"
        exit 1
    fi

    echo "$SERVICES" | nl
    echo
    read -p "Selecione o número do service: " SERVICE_NUM
    SERVICE=$(echo "$SERVICES" | sed -n "${SERVICE_NUM}p")

    if [ -z "$SERVICE" ]; then
        echo "Seleção inválida"
        exit 1
    fi
else
    CLUSTER="$1"
    SERVICE="$2"
fi

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Solicitar tag do usuário
echo "=== Build and Deploy - Projeto BIA ==="
echo
read -p "Digite a tag para a imagem (ex: v1.0.0, latest, dev): " IMAGE_TAG

if [ -z "$IMAGE_TAG" ]; then
    error "Tag não pode estar vazia!"
    exit 1
fi

# Obter Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO"

echo
log "Configurações:"
log "Tag: $IMAGE_TAG"
log "ECR URI: $ECR_URI"
log "Cluster: $CLUSTER"
log "Service: $SERVICE"
echo

# 1. Login ECR
log "1/4 - Fazendo login no ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI

# 2. Build da imagem
log "2/4 - Fazendo build da imagem Docker..."
docker build -t $ECR_URI:$IMAGE_TAG -t $ECR_URI:latest .
success "Build concluído"

# 3. Push para ECR
log "3/4 - Enviando imagem para ECR..."
docker push $ECR_URI:$IMAGE_TAG
docker push $ECR_URI:latest
success "Push concluído"

# 4. Deploy ECS
log "4/4 - Fazendo deploy no ECS..."

# Obter task definition atual e salvar em arquivo temporário
TEMP_FILE="/tmp/task-def-$$.json"
aws ecs describe-task-definition --region $REGION --task-definition $TASK_FAMILY --query 'taskDefinition' --output json > $TEMP_FILE

# Atualizar imagem na task definition
jq --arg IMAGE "$ECR_URI:$IMAGE_TAG" '.containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn, .revision, .status, .requiresAttributes, .placementConstraints, .compatibilities, .registeredAt, .registeredBy)' $TEMP_FILE > /tmp/new-task-def-$$.json

# Registrar nova task definition
NEW_REVISION=$(aws ecs register-task-definition --region $REGION --cli-input-json file:///tmp/new-task-def-$$.json --query 'taskDefinition.revision' --output text)

# Limpar arquivos temporários
rm -f $TEMP_FILE /tmp/new-task-def-$$.json

log "Nova task definition registrada: $TASK_FAMILY:$NEW_REVISION"

# Atualizar serviço com nova task definition
aws ecs update-service --region $REGION --cluster $CLUSTER --service $SERVICE --task-definition $TASK_FAMILY:$NEW_REVISION > /dev/null

success "Deploy iniciado!"
log "Imagem: $ECR_URI:$IMAGE_TAG"
log "Task Definition: $TASK_FAMILY:$NEW_REVISION"

echo
log "Aguardando estabilização do serviço..."
aws ecs wait services-stable --region $REGION --cluster $CLUSTER --services $SERVICE

echo
success "=== DEPLOY FINALIZADO COM SUCESSO ==="
success "Serviço atualizado e estável"
