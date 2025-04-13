#!/bin/bash

# Script pour convertir l'image Docker en image Apptainer

# Vérifier si Apptainer est installé
if ! command -v apptainer &> /dev/null; then
    echo "Erreur: Apptainer n'est pas installé. Veuillez l'installer d'abord."
    echo "Pour plus d'informations: https://apptainer.org/docs/admin/main/installation.html"
    exit 1
fi

# Image Docker à convertir
IMAGE_BASE="vgoupille/base-r:latest"
IMAGE_JUPYTER="vgoupille/jupyter-r:latest"

# Noms des fichiers de sortie Apptainer
OUTPUT_BASE="base-r.sif"
OUTPUT_JUPYTER="jupyter-r.sif"

echo "=== Conversion des images Docker en images Apptainer ==="
echo ""

# Demander quelle image convertir
echo "Quelle image voulez-vous convertir?"
echo "1) Image R de base ($IMAGE_BASE)"
echo "2) Image JupyterLab avec R et Python ($IMAGE_JUPYTER)"
echo "3) Les deux"
read -p "Votre choix (1/2/3): " choice

# Convertir selon le choix
if [[ "$choice" == "1" || "$choice" == "3" ]]; then
    echo "Conversion de $IMAGE_BASE en $OUTPUT_BASE..."
    apptainer build $OUTPUT_BASE docker://$IMAGE_BASE
    echo "Conversion terminée: $OUTPUT_BASE"
    echo ""
fi

if [[ "$choice" == "2" || "$choice" == "3" ]]; then
    echo "Conversion de $IMAGE_JUPYTER en $OUTPUT_JUPYTER..."
    apptainer build $OUTPUT_JUPYTER docker://$IMAGE_JUPYTER
    echo "Conversion terminée: $OUTPUT_JUPYTER"
    echo ""
fi

echo "=== Conversion terminée ==="
echo ""
echo "Pour utiliser l'image sur un cluster:"
echo "1. Copiez le fichier .sif sur le cluster"
echo "2. Utilisez: apptainer exec [image.sif] [commande]"
echo ""
echo "Exemples:"
echo "- R:           apptainer exec $OUTPUT_BASE R"
echo "- Radian:      apptainer exec $OUTPUT_BASE radian"
echo "- JupyterLab:  apptainer exec $OUTPUT_JUPYTER jupyter lab --ip=0.0.0.0 --port=8889 --no-browser"
echo "- Quarto:      apptainer exec $OUTPUT_JUPYTER quarto render document.qmd" 