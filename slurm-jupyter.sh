#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=08:00:00
#SBATCH --output=jupyter-%j.log

# Configuration
PORT=8889
IMAGE="/chemin/vers/jupyter-r.sif"
HOSTNAME=$(hostname)

# Vérifier si l'image existe
if [ ! -f "$IMAGE" ]; then
    echo "Erreur: Image Apptainer non trouvée: $IMAGE"
    echo "Veuillez modifier ce script pour pointer vers votre image .sif"
    exit 1
fi

# Créer un répertoire de travail temporaire
WORKDIR=$(mktemp -d)
cd $WORKDIR

echo "======================================================"
echo "JupyterLab démarré sur le nœud: $HOSTNAME"
echo "Port: $PORT"
echo "Image Apptainer: $IMAGE"
echo "Répertoire de travail: $WORKDIR"
echo "======================================================"
echo ""
echo "Pour vous connecter, exécutez dans un terminal local:"
echo "ssh -N -L ${PORT}:${HOSTNAME}:${PORT} VOTRE_IDENTIFIANT@VOTRE_CLUSTER"
echo ""
echo "Puis ouvrez un navigateur à l'adresse:"
echo "http://localhost:${PORT}"
echo ""
echo "======================================================"

# Démarrer JupyterLab
apptainer exec $IMAGE jupyter lab --no-browser --ip=0.0.0.0 --port=$PORT --NotebookApp.token='' --NotebookApp.password=''

# Nettoyer à la fin
rm -rf $WORKDIR 