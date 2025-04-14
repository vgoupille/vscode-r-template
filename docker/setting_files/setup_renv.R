# Script simple pour configurer renv et installer les packages nécessaires
# Memo: https://rstudio.github.io/renv/reference/install.html

# Options globales
options(
    repos = c(
        CRAN = "https://cran.rstudio.com",
        BioCsoft = "https://bioconductor.org/packages/release/bioc",
        BioCann = "https://bioconductor.org/packages/release/data/annotation",
        BioCexp = "https://bioconductor.org/packages/release/data/experiment"
    ),
    Ncpus = max(1, parallel::detectCores() - 1)
)

# Installer renv si nécessaire
if (!requireNamespace("renv", quietly = TRUE)) {
    install.packages("renv")
}

# Initialiser renv
renv::init(bare = TRUE)

# Liste des packages à installer
packages <- c(
    # Packages VSCode
    "AsioHeaders@1.22.1-2", "BH@1.84.0-0", "languageserver@0.3.16", "httpgd@2.0.2",

    # Outils R
    "rmarkdown@2.27", "usethis@2.2.2", "devtools@2.4.5",

    # Analyse de données
    "dplyr@1.1.4", "ggplot2@3.4.4", "tidyverse@2.0.0", "shiny@1.8.0", "plotly@4.10.4",

    # Intégration Python
    "reticulate@1.33.0",

    # Bioconductor
    "BiocManager@1.30.22",

    # Analyse single-cell
    "Seurat@5.0.1"
)

# Installer les packages
cat("\nInstallation des packages de base...\n")
for (pkg in packages) {
    cat("Installation de", pkg, "...\n")
    tryCatch(
        renv::install(pkg, prompt = FALSE),
        error = function(e) cat("Erreur lors de l'installation de", pkg, ":", conditionMessage(e), "\n")
    )
}

# S'assurer que BiocManager est chargé
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    stop("BiocManager n'a pas pu être installé correctement")
}
cat("\nConfiguration de BiocManager...\n")
BiocManager::install(version = "3.20", update = FALSE, ask = FALSE)

# Installer DESeq2
cat("\nInstallation de DESeq2...\n")
tryCatch(
    BiocManager::install("DESeq2", version = "3.20", update = FALSE, ask = FALSE),
    error = function(e) {
        cat("Tentative d'installation via renv...\n")
        renv::install("bioc::DESeq2", prompt = FALSE)
    }
)

# Configuration de reticulate pour utiliser l'environnement conda avec radian
cat("\nConfiguration de reticulate pour utiliser l'environnement conda...\n")
if (requireNamespace("reticulate", quietly = TRUE)) {
    # Note: .Rprofile a déjà été configuré pour utiliser env_radian
    tryCatch(
        {
            reticulate::use_condaenv("env_radian", required = TRUE)
            cat("Environnement conda 'env_radian' configuré pour reticulate.\n")
        },
        error = function(e) {
            cat("Attention: Impossible de configurer l'environnement conda 'env_radian':", conditionMessage(e), "\n")
            cat("Assurez-vous que conda est installé et que l'environnement 'env_radian' existe.\n")
        }
    )
}

# Snapshot et verrouillage
renv::snapshot(prompt = FALSE)

# Afficher les packages installés
cat("\nPackages installés :\n")
installed <- rownames(installed.packages())
for (pkg in c("dplyr", "ggplot2", "tidyverse", "BiocManager", "DESeq2", "Seurat", "reticulate")) {
    status <- if (pkg %in% installed) "installé" else "non installé"
    cat(pkg, ":", status, "\n")
}

# Copier le lockfile pour Dockerfile
file.copy("renv.lock", "/tmp/renv.lock", overwrite = TRUE)
cat("\nConfiguration terminée. Lockfile copié dans /tmp/renv.lock\n")
