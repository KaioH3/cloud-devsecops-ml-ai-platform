#! /bin/bash 
set -e
# 1. Reconstruir containers                       
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d

# 2. Verificar logs
docker compose logs -f

# 3. Testar
# Frontend: http://localhost:5000
# Backend: http://localhost:8000/docs
