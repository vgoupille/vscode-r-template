# Script for setting up renv and installing necessary packages for bioinformatics analysis
# Reference: https://rstudio.github.io/renv/reference/install.html

# Set global options for repositories and parallel processing
options(
    repos = c(
        CRAN = "https://cran.rstudio.com",
        BioCsoft = "https://bioconductor.org/packages/release/bioc",
        BioCann = "https://bioconductor.org/packages/release/data/annotation",
        BioCexp = "https://bioconductor.org/packages/release/data/experiment"
    ),
    Ncpus = max(1, parallel::detectCores() - 1)
)

# Install renv if not already installed
if (!requireNamespace("renv", quietly = TRUE)) {
    install.packages("renv")
}

# Initialize renv with bare option to create a clean environment
renv::init(bare = TRUE)

cat("\nInstalling packages with specific versions...\n")

# Define packages with specific versions
versioned_packages <- c(
    # VSCode integration packages
    "AsioHeaders@1.22.1-2", "BH@1.84.0-0", "languageserver@0.3.16", "httpgd@2.0.2",

    # R tools
    "rmarkdown@2.27", "usethis@2.2.2", "devtools@2.4.5",

    # Data analysis
    "dplyr@1.1.4", "ggplot2@3.4.4", "tidyverse@2.0.0", "shiny@1.8.0", "plotly@4.10.4",

    # Python integration
    "reticulate@1.33.0",

    # Bioconductor
    "BiocManager@1.30.22",

    # Single-cell analysis
    "Seurat@5.0.1"
)

# Install packages with version control
for (pkg in versioned_packages) {
    cat("Installing", pkg, "...\n")
    tryCatch(
        renv::install(pkg, prompt = FALSE),
        error = function(e) cat("Error installing", pkg, ":", conditionMessage(e), "\n")
    )
}

# Install additional CRAN packages without version specificity
cat("\nInstalling additional CRAN packages...\n")

# CRAN packages list (excluding already installed packages with versions)
cran_packages <- c(
    # Single-cell analysis packages
    "harmony",

    # Data manipulation packages
    "tidyr", "tibble", "readxl", "openxlsx", "Matrix",
    "writexl", "data.table", "forcats", "purrr",

    # Visualization packages
    "cowplot", "RColorBrewer", "gridExtra", "grid", "kableExtra",
    "EnhancedVolcano", "ggpubr", "ggdist", "ggrepel", "ggh4x",
    "patchwork", "viridis", "hrbrthemes", "circlize", "dendextend",
    "ComplexHeatmap", "ggsignif",

    # Additional visualization packages from r-graph-gallery
    "paletteer", "ggstatsplot", "gghighlight", "ggpattern", "geomtextpath",
    "ggraph", "ggbump", "ggiraph", "ggtext", "ggthemes", "esquisse",
    "gganimate", "ggsankey", "DT", "reactable", "gt", "gtsummary", "gtExtras",
    "tmap", "sf", "rayshader", "leaflet", "rgdal", "igraph", "chorddiag",
    "showtext", "upsetR", "streamgraph", "wordcloud2", "ggridges", "ggbeeswarm",

    # Statistical analysis packages
    "car", "rstatix", "emmeans", "ggstatsplot", "RVAideMemoire",
    "Hmisc", "zoo",

    # Example datasets
    "gapminder",

    # Documentation and reporting
    "pdftools", "magick", "knitr",
    "tsibble", "feasts", "fable"
)

# Install CRAN packages
tryCatch(
    install.packages(cran_packages),
    error = function(e) cat("Error installing CRAN packages:", conditionMessage(e), "\n")
)

# Configure BiocManager
cat("\nConfiguring BiocManager...\n")
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
BiocManager::install(version = "3.20", update = FALSE, ask = FALSE)

# Bioconductor packages list
bioc_packages <- c(
    "DESeq2", "edgeR", "ReactomePA", "clusterProfiler", "monocle3", "goseq"
)

# Install Bioconductor packages
cat("\nInstalling Bioconductor packages...\n")
tryCatch(
    BiocManager::install(bioc_packages, version = "3.20", update = FALSE, ask = FALSE),
    error = function(e) {
        cat("Error with BiocManager installation:", conditionMessage(e), "\n")
        cat("Trying alternative installation with renv...\n")
        for (pkg in bioc_packages) {
            renv::install(paste0("bioc::", pkg), prompt = FALSE)
        }
    }
)

# Configure reticulate to use conda environment with radian
cat("\nConfiguring reticulate for conda environment...\n")
if (requireNamespace("reticulate", quietly = TRUE)) {
    tryCatch(
        {
            # Set conda path explicitly
            reticulate::use_miniconda("/opt/conda")
            # Use the environment
            reticulate::use_condaenv("env_radian", required = TRUE)
            cat("Conda environment 'env_radian' configured for reticulate.\n")
        },
        error = function(e) {
            cat("Warning: Unable to configure conda environment 'env_radian':", conditionMessage(e), "\n")
            cat("Make sure conda is installed and 'env_radian' environment exists.\n")
            cat("Conda path being searched: /opt/conda/bin/conda\n")
        }
    )
}

# Create renv snapshot to lock dependencies
cat("\nCreating renv snapshot...\n")
renv::snapshot(prompt = FALSE)

# Display installed packages
cat("\nInstalled packages:\n")
installed <- rownames(installed.packages())
key_packages <- c("dplyr", "ggplot2", "tidyverse", "BiocManager", "DESeq2", "Seurat", "reticulate")
for (pkg in key_packages) {
    status <- if (pkg %in% installed) "installed" else "not installed"
    cat(pkg, ":", status, "\n")
}

# Copy lockfile for Dockerfile
file.copy("renv.lock", "/tmp/renv.lock", overwrite = TRUE)
cat("\nSetup complete. Lockfile copied to /tmp/renv.lock\n")
