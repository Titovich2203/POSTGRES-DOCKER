🚀 Company PostgreSQL Bootstrap

Un script Bash prêt à l’emploi pour déployer PostgreSQL dans un conteneur Docker,
avec une configuration optimisée haute performance pour gros serveurs
(192GB RAM, 4To stockage), incluant :
- Paramètres mémoire adaptés
- WAL et checkpoints optimisés
- Persistance du volume
- Connexions massives gérées

---

✅ Ce que ça fait

1. Crée le réseau Docker `company-network` si besoin.
2. Prépare un dossier `./data` pour persister le cluster Postgres.
3. Déploie un conteneur PostgreSQL 15 :
   - User : `company-sysadmin`
   - Password : défini dans le script ou via `.env`
   - Port exposé : 5432
   - Connecté au réseau interne `company-network`
4. Écrase le `postgresql.conf` par une configuration custom :
   - max_connections élevé (1000+)
   - shared_buffers et effective_cache_size adaptés à ta RAM
   - min_wal_size et max_wal_size pour réduire les checkpoints forcés
   - work_mem généreux pour requêtes lourdes
   - Autres tweaks recommandés
5. Redémarre proprement le conteneur pour appliquer les paramètres.
6. Vérifie que tous les réglages sont actifs.

---

📂 Structure

project/
 ├─ init-postgres.sh     # Script principal
 ├─ .env                 # Variables sensibles (mot de passe)
 └─ data/                # Volume de données Postgres persistant

---

⚙️ Pré-requis

- Docker installé et fonctionnel (`docker ps` doit répondre)
- Port 5432 libre sur ton serveur
- Droits sudo pour lancer Docker si nécessaire

---

🚦 Usage

1) Cloner ton repo (exemple) :
  git clone https://github.com/tonorg/tonrepo.git
  cd tonrepo

2) Préparer ton `.env` (optionnel mais recommandé) :
  POSTGRES_PASSWORD="M0tDePasseUltraSecure"

  Ajoute `.env` à ton `.gitignore` pour ne jamais versionner tes secrets.

3) Rendre exécutable et lancer :
  chmod +x init-postgres.sh
  ./init-postgres.sh

---

🔍 Vérifier le résultat

Après le setup :
  docker ps          # Vérifie que company-db tourne
  docker network ls  # Vérifie company-network

Dans Postgres :
  docker exec -it company-db psql -U company-sysadmin -d postgres -c "SHOW ALL;"

---

🧹 Pour supprimer proprement

Si besoin :
  docker stop company-db
  docker rm company-db

Les données restent dans ./data/ ➜ tu ne perds rien.

---

⚡ Paramètres par défaut

Paramètre                  | Valeur
----------------------------|------------------------
max_connections             | 1000
shared_buffers              | 48GB
effective_cache_size        | 144GB
work_mem                    | 64MB
maintenance_work_mem        | 2GB
min_wal_size / max_wal_size | 4GB / 16GB
checkpoint_completion_target| 0.9
wal_buffers                 | auto
effective_io_concurrency    | 200

👉 Ajuste selon tes besoins et ton usage réel.

---

🗂️ Best practices

✅ Monte un pgBouncer si tu prévois >1000 connexions
✅ Sauvegarde ton volume ./data/ régulièrement
✅ Surveille avec pg_stat_bgwriter et pg_stat_activity
✅ Versionne ton postgresql.conf dans ton Git (hors secrets)

---

🤝 Contributions

Ce script est une base : libre à toi de l’adapter, l’améliorer ou le partager pour tous tes serveurs Company.
Merge requests bienvenues !

---

🚀 Bon déploiement & DB haute performance !
