#!/bin/bash
set -e

echo "=== Setup Backend VM ==="

# Atualizar sistema
apt-get update -y && apt-get upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu
systemctl enable docker --now

# Aguardar Docker inicializar
sleep 10

# Instalar OCI CLI
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" -- --accept-all-defaults

# Configurar firewall
ufw allow 22
ufw allow 8000
ufw --force enable

echo "=== Backend VM configurada com sucesso! ==="
