#!/bin/bash

# Logs speichern
LOGFILE="/var/log/prototype_install.log"
exec > >(tee -a $LOGFILE) 2>&1

# Updates und grundlegende Tools installieren
echo "Starte Installation..."

# Docker installieren
echo "Docker installieren..."
sudo apt-get update && sudo apt upgrade -y
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker starten und aktivieren
echo "Docker starten..."
sudo systemctl start docker
sudo systemctl enable docker

# Docker Compose installieren
echo "Docker Compose installieren..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Git und Jq installieren
echo "Git und jq installieren..."
sudo apt update && sudo apt install git -y
sudo apt install jq

# Git-Repository klonen
echo "Klonen des Repositories..."
git clone https://github.com/buecktobias/AWP-EDC.git /opt/awp-edc

# Docker Compose starten
echo "Starte Docker Compose..."
cd /opt/awp-edc
docker-compose up -d

# Healthcheck-Info
echo "Deployment abgeschlossen! Testen Sie mit: curl http://localhost:8080/health"
