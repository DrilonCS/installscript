#!/bin/bash

# Logs speichern
LOGFILE="/var/log/prototype_install.log"
exec > >(tee -a $LOGFILE) 2>&1

# Updates und grundlegende Tools installieren
echo "Starte Installation..."
apt-get update
apt-get install -y docker.io git docker-compose jq

# Docker starten und aktivieren
systemctl start docker
systemctl enable docker

# Git-Repository klonen
echo "Klonen des Repositories..."
git clone https://github.com/buecktobias/AWP-EDC.git /opt/awp-edc

# Docker Compose starten
echo "Starte Docker Compose..."
cd /opt/awp-edc
docker-compose up -d

# Healthcheck-Info
echo "Deployment abgeschlossen! Testen Sie mit: curl http://localhost:8080/health"
