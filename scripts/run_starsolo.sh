#!/bin/bash

# Script pour exécuter des commandes dans l'environnement STARsolo
# Usage: ./run_starsolo.sh [command]

# Activer l'environnement STARsolo
source ~/.bashrc
conda activate env_STARsolo

# Si une commande est fournie, l'exécuter; sinon ouvrir un shell interactif
if [ $# -gt 0 ]; then
    echo "Exécution de la commande dans l'environnement STARsolo : $@"
    "$@"
else
    echo "Shell interactif activé pour l'environnement STARsolo"
    echo "Vous pouvez exécuter directement STARsolo avec la commande 'STAR'"
    exec $SHELL
fi 