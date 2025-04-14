#!/usr/bin/env bash
CONDA_ENV_NAME=$1
PYTHON_VER=$2

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
elif [ "$ARCH" = "aarch64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Install Miniconda
wget $MINICONDA_URL -O miniconda.sh
bash miniconda.sh -b -p /opt/conda
rm miniconda.sh

# Add conda to PATH
export PATH=/opt/conda/bin:$PATH
echo "export PATH=/opt/conda/bin:$PATH" >> ~/.bashrc

# Initialize conda
/opt/conda/bin/conda init bash
source ~/.bashrc

# Create conda environment from yml file
conda env create -f ./pkgs/environment.yml

# Add conda activation to .bashrc 