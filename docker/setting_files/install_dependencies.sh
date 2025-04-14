#!/usr/bin/env bash

# Installing dependencies (optimisé pour rocker/r-ver comme base)
apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    wget \
    git \
    jq \
    r-cran-rjava \
    libgdal-dev \
    ca-certificates \
    libssl-dev \
    libudunits2-dev \
    openjdk-8-jdk \
    screen \
    texinfo \
    texlive \
    texlive-fonts-extra \
    vim \
    xvfb \
    sudo \
    curl \
    libgit2-dev \
    libmagick++-dev \
    tmux \
    python3-launchpadlib \
    python3.10-dev \
    python3.10-venv \
    python3-pip \
    r-cran-rgdal \
    libproj-dev \
    pandoc \
    unixodbc \
    && rm -rf /var/lib/apt/lists/*