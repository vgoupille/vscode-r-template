# Projet d'Analyse RNA-seq

Ce projet contient un environnement spécifique pour l'analyse RNA-seq utilisant DESeq2 et edgeR.

## Structure du Projet

```
rna_seq_project/
├── R/               # Scripts R
├── data/            # Données brutes
├── results/         # Résultats des analyses
└── renv/            # Environnement renv
```

## Installation

1. Cloner ce dépôt
2. Lancer R dans le dossier du projet
3. Exécuter le script d'initialisation :
```R
source("R/init.R")
```

## Utilisation

L'environnement est isolé et contient :
- DESeq2 et edgeR pour l'analyse différentielle
- clusterProfiler pour l'analyse d'enrichissement
- org.Hs.eg.db pour les annotations
- EnhancedVolcano pour les visualisations
- pheatmap pour les heatmaps
- DEGreport pour le reporting

## Reproduction de l'Environnement

Pour reproduire exactement le même environnement :
```R
renv::restore()
```

## Mise à Jour des Packages

Pour mettre à jour les packages :
```R
renv::update()
renv::snapshot()
``` 