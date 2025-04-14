# Makefile for Docker operations
# CPU architecture, defaults to amd64 if not specified
CPU ?= amd64

# Docker image information
IMAGE_NAME = vgoupille/baser
IMAGE_TAG = $(CPU).4.4.0

# Variables for build args
PYTHON_VER ?= 3.10
R_VERSION ?= 4.4.0
R_VERSION_MAJOR = $(shell echo $(R_VERSION) | cut -d. -f1)
R_VERSION_MINOR = $(shell echo $(R_VERSION) | cut -d. -f2)
R_VERSION_PATCH = $(shell echo $(R_VERSION) | cut -d. -f3)
CONDA_ENV_NAME ?= r-env
QUARTO_VERSION ?= 1.5.47
VENV_NAME ?= r-env

# Docker compose file path
DOCKER_COMPOSE = docker/docker-compose.yml

# Architectures supportées pour multi-arch
PLATFORMS = linux/amd64,linux/arm64

.PHONY: help build start stop restart shell login publish clean publish-multi-arch setup-buildx clean-buildx reset-docker

help:
	@echo "Available commands:"
	@echo "  make build              - Build the Docker image for single architecture ($(CPU))"
	@echo "  make start              - Start the container"
	@echo "  make stop               - Stop the container"
	@echo "  make restart            - Restart the container"
	@echo "  make shell              - Open a shell in the container"
	@echo "  make login              - Login to Docker Hub"
	@echo "  make publish            - Publish the image to Docker Hub (single arch: $(CPU))"
	@echo "  make setup-buildx       - Configure Docker buildx pour multi-architecture"
	@echo "  make publish-multi-arch - Publish the image for multiple architectures"
	@echo "  make clean              - Remove containers and images"
	@echo "  make reset-docker       - Reset Docker"

build:
	@echo "Building Docker image $(IMAGE_NAME):$(IMAGE_TAG)..."
	CPU=$(CPU) docker-compose -f $(DOCKER_COMPOSE) build r-dev

start:
	@echo "Starting container..."
	CPU=$(CPU) docker-compose -f $(DOCKER_COMPOSE) up -d r-dev

stop:
	@echo "Stopping container..."
	CPU=$(CPU) docker-compose -f $(DOCKER_COMPOSE) down

restart: stop start

shell:
	@echo "Opening shell in container..."
	CPU=$(CPU) docker-compose -f $(DOCKER_COMPOSE) exec r-dev /bin/bash

login:
	@echo "Logging in to Docker Hub..."
	docker login

publish: build login
	@echo "Publishing image $(IMAGE_NAME):$(IMAGE_TAG) to Docker Hub..."
	docker push $(IMAGE_NAME):$(IMAGE_TAG)

setup-buildx:
	@echo "Configuration de Docker buildx pour multi-architecture..."
	docker buildx rm multiarch || true
	docker buildx create --name multiarch --use
	docker buildx inspect --bootstrap

publish-multi-arch: login setup-buildx
	@echo "Construction et publication de l'image pour les architectures: $(PLATFORMS)"
	docker buildx build \
		--platform $(PLATFORMS) \
		--file docker/Dockerfile.base-r \
		--build-arg PYTHON_VER=$(PYTHON_VER) \
		--build-arg R_VERSION=$(R_VERSION) \
		--build-arg CONDA_ENV_NAME=$(CONDA_ENV_NAME) \
		--build-arg QUARTO_VERSION=$(QUARTO_VERSION) \
		-t $(IMAGE_NAME):$(R_VERSION) \
		--push \
		.

clean-buildx:
	@echo "Nettoyage du cache de buildx..."
	docker buildx rm multiarch || true
	docker buildx prune -f
	docker system df
	docker system prune -f
	docker system prune -a -f --volumes

clean:
	@echo "Cleaning up containers and images..."
	CPU=$(CPU) docker-compose -f $(DOCKER_COMPOSE) down --rmi all 

reset-docker:
	@echo "⚠️ ATTENTION: Ceci va supprimer TOUTES les images Docker, conteneurs, volumes et réseaux ⚠️"
	@echo "Arrêtez Docker Desktop avant d'exécuter cette commande"
	@read -p "Êtes-vous sûr? (o/n) " confirm; \
	if [ "$$confirm" = "o" ] || [ "$$confirm" = "O" ]; then \
		echo "Suppression des données Docker..."; \
		rm -rf ~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw; \
		echo "Redémarrez Docker Desktop maintenant"; \
	else \
		echo "Opération annulée"; \
	fi 

build-base-r:
	docker build \
		--build-arg R_VERSION=$(R_VERSION) \
		--build-arg PYTHON_VER=$(PYTHON_VER) \
		--build-arg CONDA_ENV_NAME=$(CONDA_ENV_NAME) \
		--build-arg QUARTO_VERSION=$(QUARTO_VERSION) \
		-f docker/Dockerfile.base-r \
		-t $(IMAGE_NAME):$(R_VERSION) \
		. 