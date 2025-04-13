#!/bin/bash

# Script wrapper pour lancer Radian depuis une image Apptainer
# Utilisation: ~/bin/radian-apptainer.sh (à placer dans votre répertoire bin personnel)

# Chemin vers l'image Apptainer (à modifier selon votre emplacement)
APPTAINER_IMAGE="/chemin/vers/jupyter-r.sif"

# Vérifier si l'image existe
if [ ! -f "$APPTAINER_IMAGE" ]; then
    echo "Erreur: Image Apptainer non trouvée: $APPTAINER_IMAGE"
    echo "Veuillez modifier ce script pour pointer vers votre image .sif"
    exit 1
fi

# Exécuter Radian dans l'image Apptainer, passer tous les arguments
apptainer exec "$APPTAINER_IMAGE" radian "$@" 