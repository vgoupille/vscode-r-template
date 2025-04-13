#!/usr/bin/env bash

# Script pour lancer VS Code avec le choix de l'environnement à utiliser

echo "Quel environnement souhaitez-vous utiliser ?"
echo "1) Environnement R de base (r-dev)"
echo "2) Environnement JupyterLab avec R et Python (jupyter-r)"
read -p "Votre choix (1/2): " choice

if [ "$choice" = "1" ]; then
    service="r-dev"
    echo "Lancement de VS Code avec l'environnement R de base..."
elif [ "$choice" = "2" ]; then
    service="jupyter-r"
    echo "Lancement de VS Code avec l'environnement JupyterLab..."
else
    echo "Choix non valide. Utilisation de l'environnement par défaut (r-dev)."
    service="r-dev"
fi

# Exporter la variable d'environnement pour le service choisi
export DEV_SERVICE=$service

# Lancer VS Code avec le bon service
code . 