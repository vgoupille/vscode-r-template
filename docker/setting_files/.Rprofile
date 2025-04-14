# Configure renv
if (file.exists("renv/activate.R")) {
    source("renv/activate.R")
}

# Set CRAN mirror
options(repos = Sys.getenv("CRAN_MIRROR"))

# Configure renv settings
options(renv.config.auto.snapshot = FALSE) # Désactiver les snapshots automatiques
options(renv.config.cache.enabled = TRUE)
options(renv.config.sandbox.enabled = TRUE) # Active le sandboxing
options(renv.config.install.verbose = TRUE) # Plus d'informations lors de l'installation
options(renv.config.install.shortcuts = FALSE) # Désactiver les raccourcis pour utiliser les versions exactes
options(renv.config.restore.library.deps = TRUE) # Restaurer également les dépendances de la bibliothèque

# Source: https://github.com/REditorSupport/vscode-R/wiki/Plot-viewer#svg-in-httpgd-webpage
if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
    if ("httpgd" %in% .packages(all.available = TRUE)) {
        options(vsc.plot = FALSE)
        options(device = function(...) {
            httpgd::hgd(silent = TRUE)
            .vsc.browser(httpgd::hgd_url(history = FALSE), viewer = "Beside")
        })
    }
}

# Source: https://github.com/REditorSupport/vscode-R/wiki/R-Session-watcher#advanced-usage-for-self-managed-r-sessions
if (interactive()) {
    source("/root/.vscode-R/init.R")
}

# Configuration de reticulate pour utiliser l'environnement conda avec radian
if (interactive() && requireNamespace("reticulate", quietly = TRUE)) {
    tryCatch(
        {
            reticulate::use_condaenv("env_radian", required = TRUE)
            # Définir comme environnement par défaut
            Sys.setenv(RETICULATE_PYTHON = reticulate::conda_python("env_radian"))
            cat("Python environment configuré avec env_radian\n")
        },
        error = function(e) {
            cat("Note: Impossible de configurer l'environnement conda 'env_radian':", conditionMessage(e), "\n")
        }
    )
}

# Afficher les versions des packages chargés au démarrage d'une session R
cat("Environnement R avec versions fixes:\n")
cat("R version", R.version.string, "\n")
cat("Les packages seront chargés à partir du projet renv.\n")
