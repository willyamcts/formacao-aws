#!/bin/sh

# Variáveis de conexão
DB_HOST="bia-aurora.cluster-cqzmsio0yzwj.us-east-1.rds.amazonaws.com"
DB_PORT="5432"
DB_NAME="bia"
DB_USER='postgres'
DB_PASSWORD='SENHA'

# Comando psql para se conectar e executar uma consulta SQL
for i in $(ls data-*.csv); do
  echo "Importando arquivo $i"
  PASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" \
    -p "$DB_PORT" \
    -d "$DB_NAME" \
    -U "$DB_USER" \
    -c "$DB_USER" -c "\COPY public.\"Tarefas\" FROM "data-${i}.csv" DELIMITER ',' CSV"
done
