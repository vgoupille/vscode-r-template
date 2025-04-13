#!/bin/bash
# Script pour publier l'image R sur Docker Hub

# Vérifier si les variables d'environnement sont définies
if [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PASSWORD" ]; then
  echo "Erreur: DOCKER_USER et DOCKER_PASSWORD doivent être définis"
  echo "Utilisez: export DOCKER_USER=vgoupille && export DOCKER_PASSWORD=votre_password"
  exit 1
fi

# Architecture CPU (amd64 par défaut)
CPU=${CPU:-amd64}
TAG_VERSION="$CPU.4.4.0"
IMAGE_NAME="vgoupille/baser:$TAG_VERSION"

# Se connecter à Docker Hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin

if [ $? -ne 0 ]; then
  echo "Échec de la connexion à Docker Hub"
  exit 1
fi

# Publier l'image
echo "Publication de $IMAGE_NAME..."
docker push "$IMAGE_NAME"

# Optionnel: créer un tag "latest"
if [ "$CREATE_LATEST" = "true" ]; then
  LATEST_TAG="vgoupille/baser:latest"
  echo "Création du tag latest..."
  docker tag "$IMAGE_NAME" "$LATEST_TAG"
  docker push "$LATEST_TAG"
fi

echo "Publication terminée!" 