# Initialize renv for this project
if (!requireNamespace("renv", quietly = TRUE)) {
    install.packages("renv", repos = "https://cran.rstudio.com/")
}

# Initialize renv
renv::init()

# Install Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", repos = "https://cran.rstudio.com/")
}

# Install required packages
BiocManager::install(c(
    "DESeq2",
    "edgeR",
    "clusterProfiler",
    "org.Hs.eg.db",
    "EnhancedVolcano",
    "pheatmap",
    "DEGreport"
))

# Install CRAN packages
install.packages(c(
    "tidyverse",
    "ggplot2",
    "plotly",
    "knitr",
    "rmarkdown"
))

# Take a snapshot of the environment
renv::snapshot()
