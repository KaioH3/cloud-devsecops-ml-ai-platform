#!/bin/bash
set -e

echo "=== Setup Frontend VM ==="

# Atualizar sistema
apt-get update -y && apt-get upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu
systemctl enable docker --now

# Aguardar Docker inicializar
sleep 10

# Configurar firewall
ufw allow 22
ufw allow 5000
ufw allow 80
ufw --force enable

echo "=== Frontend VM configurada com sucesso! ==="
