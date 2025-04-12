#!/usr/bin/env bash

# Script pour démarrer l'environnement avec Docker Compose

# Identify the CPU type (M1 vs Intel)
if [[ $(uname -m) ==  "aarch64" ]] || [[ $(uname -m) ==  "arm64" ]] ; then
  export CPU="arm64"
else
  export CPU="amd64"
fi

echo "Architecture CPU détectée: $CPU"
echo "Démarrage de l'environnement R avec Docker Compose..."

# Run docker-compose
docker-compose up -d

echo "Environnement démarré."
echo "Pour accéder au shell du conteneur: docker exec -it r-dev-container bash"
echo "Pour arrêter l'environnement: docker-compose down" 