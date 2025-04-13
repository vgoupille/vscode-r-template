#!/usr/bin/env bash

# Exit on error
set -e

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    CPU="arm64"
else
    CPU="amd64"
fi

echo "Detected architecture: $CPU"
echo "Starting JupyterLab container with R and multiple conda environments"

# Run the JupyterLab container
CPU=$CPU docker-compose -f docker/docker-compose.yml up jupyter-r

# NOTE: To run in detached mode, add -d flag:
# CPU=$CPU docker-compose -f docker/docker-compose.yml up -d jupyter-r 