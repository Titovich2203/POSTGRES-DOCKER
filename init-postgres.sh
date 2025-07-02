#!/bin/bash

# ===============================
# 🚀 Company PostgreSQL Setup
# ===============================

# === 1️⃣ Réseau Docker ===
echo "✅ Vérification du réseau Docker..."
if ! docker network ls | grep -q "company-network"; then
  docker network create company-network
  echo "✅ Réseau 'company-network' créé."
else
  echo "✅ Réseau 'company-network' déjà existant."
fi

# === 2️⃣ Préparer le volume ===
echo "✅ Préparation dossier ./data"
mkdir -p ./data

# === 3️⃣ Déployer le conteneur ===
echo "✅ Déploiement du conteneur company-db"
docker run -d \
  --name company-db \
  --network="company-network" \
  -e POSTGRES_USER=company-sysadmin \
  -e POSTGRES_PASSWORD="M0tDePasseUltraSecure" \
  -p 5432:5432 \
  -v $(pwd)/data:/var/lib/postgresql/data \
  --restart unless-stopped \
  postgres:15

# === 4️⃣ Attendre que Postgres init ===
echo "⏳ Attente de l'init de la base (5s)..."
sleep 5

# === 5️⃣ Remplacer postgresql.conf ===
echo "✅ Application de la conf optimisée..."
CONF_PATH="./data/postgresql.conf"

cat <<EOF > $CONF_PATH
# 🚀 Company Optimized postgresql.conf

max_connections = 1000
shared_buffers = 48GB
work_mem = 64MB
maintenance_work_mem = 2GB
effective_cache_size = 144GB

min_wal_size = 4GB
max_wal_size = 16GB
checkpoint_completion_target = 0.9
wal_buffers = -1

default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
EOF

echo "✅ Nouvelle conf écrite dans $CONF_PATH"

# === 6️⃣ Redémarrer le conteneur ===
echo "♻️ Restart du conteneur pour appliquer les réglages..."
docker restart company-db

# === 7️⃣ Vérifier ===
echo "✅ Vérification de la conf Postgres..."
docker exec -it company-db psql -U company-sysadmin -d postgres -c "SHOW ALL;" | grep -E 'max_connections|shared_buffers|work_mem|maintenance_work_mem|min_wal_size|max_wal_size|checkpoint_completion_target|wal_buffers'

echo "🎉 Setup PostgreSQL Company boosté terminé !"
