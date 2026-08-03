#!/bin/bash

set -e

CONTAINER_NAME="mssql2022"
SA_PASSWORD="StrongPassword@123"
PORT="1433"

echo "Checking Docker..."

if ! command -v docker &>/dev/null; then
    echo "Docker not installed!"
    exit 1
fi

echo "Pulling SQL Server 2022 image..."
docker pull mcr.microsoft.com/mssql/server:2022-latest

echo "Removing existing container..."

docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Creating volume..."
docker volume create mssql-data

echo "Starting SQL Server..."

docker run -d \
  --name $CONTAINER_NAME \
  --hostname $CONTAINER_NAME \
  -e ACCEPT_EULA=Y \
  -e MSSQL_PID=Developer \
  -e MSSQL_SA_PASSWORD="$SA_PASSWORD" \
  -p $PORT:1433 \
  -v mssql-data:/var/opt/mssql \
  --restart unless-stopped \
  mcr.microsoft.com/mssql/server:2022-latest

echo ""
echo "Waiting for SQL Server..."
sleep 30

docker ps

echo ""
echo "========================================"
echo "SQL Server Installed Successfully"
echo "========================================"
echo "Server : localhost,$PORT"
echo "User   : sa"
echo "Pass   : $SA_PASSWORD"
echo ""