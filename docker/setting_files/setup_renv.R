#!/usr/bin/env Rscript

# Script pour la configuration de renv et l'installation des packages nécessaires pour l'analyse bioinformatique

# example of installation:
# if (FALSE) { # \dontrun{

# # install the latest version of 'digest'
# renv::install("digest")

# # install an old version of 'digest' (using archives)
# renv::install("digest@0.6.18")

# # install 'digest' from GitHub (latest dev. version)
# renv::install("eddelbuettel/digest")

# # install a package from GitHub, using specific commit
# renv::install("eddelbuettel/digest@df55b00bff33e945246eff2586717452e635032f")

# # install a package from Bioconductor
# # (note: requires the BiocManager package)
# renv::install("bioc::Biobase")

# # install a package, specifying path explicitly
# renv::install("~/path/to/package")

# # install packages as declared in the project DESCRIPTION file
# renv::install()

# } # }

# Référence: https://rstudio.github.io/renv/reference/install.html

# Définir les options globales pour les dépôts
options(repos = c(
    # Utiliser une version stable et récente de CRAN
    CRAN = "https://packagemanager.posit.co/cran/2025-04-14/",
    # Utiliser les dépôts BioConductor 3.20 (version plus récente compatible avec R 4.4)
    BioCsoft = "https://bioconductor.org/packages/3.20/bioc",
    BioCann = "https://bioconductor.org/packages/3.20/data/annotation",
    BioCexp = "https://bioconductor.org/packages/3.20/data/experiment"
))

# Fonction pour gérer les erreurs d'installation
safe_install <- function(package, message = NULL) {
    if (!is.null(message)) cat(paste0(message, "\n"))
    tryCatch(
        {
            install.packages(package)
            return(TRUE)
        },
        error = function(e) {
            cat(paste0("Erreur lors de l'installation de ", package, ": ", e$message, "\n"))
            return(FALSE)
        }
    )
}

# Installer renv s'il n'est pas déjà installé
if (!requireNamespace("renv", quietly = TRUE)) {
    safe_install("renv", "Installation de renv...")
}

# Initialiser renv avec l'option bare pour créer un environnement propre
cat("Initialisation de renv...\n")
renv::init(bare = TRUE, force = TRUE, restart = FALSE)

# Définir les mêmes dépôts pour les snapshots renv
options(renv.snapshot.repos = getOption("repos"))

# Fonction pour installer un package avec gestion des erreurs
failed_packages <- list() # Liste pour stocker les packages qui échouent à l'installation

install_package <- function(package_spec) {
    tryCatch(
        {
            cat(sprintf("Installation de %s\n", package_spec))
            renv::install(package_spec)
            return(TRUE)
        },
        error = function(e) {
            cat(sprintf("⚠️ ÉCHEC: Installation de %s: %s\n", package_spec, e$message))
            failed_packages <<- c(failed_packages, list(list(package = package_spec, error = e$message)))
            return(FALSE)
        }
    )
}

# Installation des packages de support VSCode
cat("Installation des packages de support VSCode...\n")
install_package("languageserver@0.3.16")
install_package("httpgd@2.0.2")
install_package("rmarkdown@2.27")

# Installation des packages de développement R
cat("Installation des packages de développement...\n")
install_package("usethis@2.2.2")
install_package("devtools@2.4.5")

# install_package("RColorBrewer")
# install_package("cowplot")
# install_package("RColorBrewer")
# install_package("cowplot")
# install_package("ggrepel")
install_package("ggpubr")


# Installation des packages d'analyse de données
cat("Installation des packages d'analyse de données...\n")
install_package("tidyverse@2.0.0")
# install_package("dplyr@1.1.3")
# install_package("tidyr@1.3.0")
# install_package("ggplot2@3.4.3")
install_package("shiny@1.7.4")
install_package("plotly@4.10.2")

# Installation des packages bioinformatiques essentiels
cat("Installation des packages bioinformatiques...\n")
# install_package("Matrix")
# Single-cell analysis
install_package("seurat@5.2.1")
# Normalisation and Integration of single-cell data
# install_package("sctransform") #always include in the seurat package
install_package("harmony@1.2.3")


# installation avec bioconductor
install_package("bioc::BiocManager")
# Differential expression analysis
install_package("bioc::limma")
install_package("bioc::edgeR")
install_package("bioc::DESeq2")
# trajectory analysis
install_package("bioc::monocle")
# Enrichment analysis
install_package("bioc::ReactomePA") # permet de gérer les enrichissements
install_package("bioc::clusterProfiler") # permet de gérer les enrichissements
install_package("bioc::goseq") # permet de gérer les enrichissements

# Installation des packages additionnels pour l'analyse avancée
cat("Installation des packages pour l'analyse avancée...\n")
install_package("patchwork") # permet de combiner les graphiques
install_package("VGAM") # permet de gérer les distributions de probabilités
install_package("foreach") # permet de paralléliser les calculs
install_package("doParallel") # permet de paralléliser les calculs

# Installation des packages pour l'intégration Python
cat("Installation des packages pour l'intégration Python...\n")
install_package("reticulate")



#   # Install scCustomize
install_package("scCustomize@3.0.1") # permet de converture anndata en seurat et l'inverse
install_package("anndata@0.7.5.6") # permet de gérer les données d'anndata


# Additional packages
install_package("bioc::ComplexHeatmap") # permet de gérer les heatmaps
install_package("circlize") # permet de gérer les cercles
install_package("paletteer") # permet de gérer les palettes de couleurs
install_package("ggrepel") # permet de gérer les labels
install_package("ggthemes") # permet de gérer les thèmes
install_package("ggh4x") # permet de gérer les graphiques
install_package("hrbrthemes") # permet de gérer les thèmes



# Capture de l'environnement
cat("Capture de l'environnement renv...\n")
renv::snapshot(prompt = FALSE)

# Affichage du résumé des installations
cat("\n===== RÉSUMÉ D'INSTALLATION =====\n")
if (length(failed_packages) == 0) {
    cat("✅ Tous les packages ont été installés avec succès.\n")
} else {
    cat(sprintf("⚠️ %d package(s) n'ont pas pu être installés:\n", length(failed_packages)))
    for (pkg in failed_packages) {
        cat(sprintf("  - %s\n", pkg$package))
    }
    cat("\nLes packages restants ont été installés avec succès.\n")
}

cat("Configuration de renv terminée.\n")



# # Set CRAN mirror first
# options(repos = c(CRAN = "https://cloud.r-project.org"))

# # Install BiocManager for Bioconductor packages
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")

# # Install renv
# if (!requireNamespace("renv", quietly = TRUE))
#   install.packages("renv")
# library(renv)

# # Récupérer l'environnement figé si déjà existant
# if (file.exists("renv.lock")) {
#   # Activer la gestion des versions avec renv
#   renv::restore()
# } else {
#   # Install devtools for GitHub installations
#   renv::install("devtools")

#   # Install Seurat from GitHub instead of CRAN
#   renv::install("satijalab/seurat@v5.2.1")

#   # Install other CRAN packages
#   renv::install("Matrix")
#   renv::install("dplyr")
#   renv::install("tidyr")
#   renv::install("ggplot2")
#   renv::install("cowplot")
#   renv::install("forcats")
#   renv::install("ggpubr")
#   renv::install("ggrepel")
#   renv::install("RColorBrewer")

#   # Install scCustomize from GitHub
#   renv::install("samuel-marsh/scCustomize")

#   # Install Python packages
#   renv::install("reticulate")
#   renv::install("python")

#   # Install additional packages
#   renv::install("gridExtra")
#   renv::install("patchwork")
#   renv::install("VGAM")
#   renv::install("gplots")
#   renv::install("pracma")
#   renv::install("resample")
#   renv::install("foreach")
#   renv::install("distances")
#   renv::install("doParallel")

#   # Sauvegarder l'état de l'environnement
#   renv::snapshot()
# }
