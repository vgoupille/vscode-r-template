#!/usr/bin/env bash

# Installing dependencies (optimized for rocker/r-ver as base)
# Dependencies are grouped by category:
# - System tools and basic utilities (apt-utils, wget, git, etc.)
# - Compilers and development tools (gfortran, g++)
# - Compression libraries and text manipulation
# - Graphics and display libraries
# - Web development and network libraries
# - GIS support and spatial data processing
# - Java dependencies and R-specific libraries
# - Documentation and internationalization support
# - Python environment for R integration

apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    wget \
    git \
    jq \
    sudo \
    curl \
    vim \
    screen \
    tmux \
    make \
    pandoc \
    unixodbc \
    xvfb \
    gfortran \
    g++ \
    libbz2-dev \
    libzstd-dev \
    liblzma-dev \
    libpcre2-dev \
    libreadline-dev \
    libfontconfig1-dev \
    libx11-dev \
    libxt-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libtiff5-dev \
    libjpeg-dev \
    libpng-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgdal-dev \
    r-cran-rgdal \
    libproj-dev \
    libudunits2-dev \
    r-cran-rjava \
    openjdk-8-jdk \
    libgit2-dev \
    libmagick++-dev \
    texinfo \
    texlive \
    texlive-fonts-extra \
    tzdata \
    ca-certificates \
    locales \
    python3-launchpadlib \
    python3.10-dev \
    python3.10-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*