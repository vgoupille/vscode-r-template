#!/usr/bin/env bash

echo "Build the docker"

# Enable BuildKit for faster builds
export DOCKER_BUILDKIT=1

# Parameters
user_name="vgoupille"
image_label="baser"
r_version="4.4.0"
r_major=$(echo $r_version | cut -d. -f1)
r_minor=$(echo $r_version | cut -d. -f2)
r_patch=$(echo $r_version | cut -d. -f3)
quarto_ver="1.5.47"
python_ver="3.10"
venv_name="r-env"

# Identify the CPU type (M1 vs Intel)
if [[ $(uname -m) ==  "aarch64" ]] ; then
  CPU="arm64"
elif [[ $(uname -m) ==  "arm64" ]] ; then
  CPU="arm64"
else
  CPU="amd64"
fi

# Setting the image name
ver=${r_major}.${r_minor}.${r_patch}
tag="${CPU}.${ver}"
docker_file=docker/Dockerfile.base-r
image_name=$user_name/$image_label:$tag

echo "Image name: $image_name"

# Build
docker build . \
  -f $docker_file --progress=plain \
  --build-arg PYTHON_VER=$python_ver \
  --build-arg R_VERSION=$r_version \
  --build-arg QUARTO_VERSION=$quarto_ver \
  --build-arg VENV_NAME=$venv_name \
   -t $image_name

# Push
if [[ $? = 0 ]] ; then
echo "Pushing docker..."
docker push $image_name
else
echo "Docker build failed"
fi