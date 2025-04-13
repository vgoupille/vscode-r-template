#!/usr/bin/env bash

# Exit on error
set -e

# Enable BuildKit for faster builds
export DOCKER_BUILDKIT=1

# Default values
DEFAULT_TAG=$(date +%Y%m%d)
DEFAULT_VERSION="latest"

# Parse arguments
VERSION=${1:-$DEFAULT_VERSION}
TAG=${2:-$DEFAULT_TAG}

echo "Building JupyterLab Docker image with R and multiple conda environments"
echo "Base image: vgoupille/base-r:latest"
echo "New image tag: vgoupille/jupyter-r:$VERSION-$TAG"

# Build the docker image
docker build \
    -t vgoupille/jupyter-r:$VERSION-$TAG \
    -t vgoupille/jupyter-r:$VERSION \
    -t vgoupille/jupyter-r:latest \
    -f docker/Dockerfile.jupyter .

echo "Image built successfully: vgoupille/jupyter-r:$VERSION-$TAG"
echo "To push the image to Docker Hub, run:"
echo "docker push vgoupille/jupyter-r:$VERSION-$TAG"
echo "docker push vgoupille/jupyter-r:$VERSION"
echo "docker push vgoupille/jupyter-r:latest" 