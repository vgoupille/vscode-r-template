# Advanced R script for gene correlation analysis
# This script demonstrates correlation analysis and heatmap visualization

# Load required libraries
library(ggplot2)
library(dplyr)
library(pheatmap)  # For heatmap
library(RColorBrewer)  # For color palettes

# Set seed for reproducibility
set.seed(123)

# Simulate gene expression data for 20 genes across 30 samples
# This simulates data similar to RNA-seq normalized counts
n_genes <- 20
n_samples <- 30

# Create gene names (with some known gene families)
gene_names <- c(
  "BRCA1", "BRCA2", "TP53", "PTEN", "KRAS", 
  "EGFR", "HER2", "MYC", "PIK3CA", "AKT1",
  paste0("GENE", 1:(n_genes-10))
)

# Create sample IDs with condition information
sample_ids <- paste0("Sample_", 1:n_samples)
conditions <- rep(c("Control", "Treatment A", "Treatment B"), each = n_samples/3)

# Create a correlation structure between genes
# Genes in same pathways will be correlated
correlation_matrix <- matrix(0.1, nrow = n_genes, ncol = n_genes)
diag(correlation_matrix) <- 1

# Genes in same pathway are more correlated
# BRCA pathway
correlation_matrix[1:2, 1:2] <- 0.8
# PI3K pathway
correlation_matrix[4, 9] <- correlation_matrix[9, 4] <- 0.7
correlation_matrix[9, 10] <- correlation_matrix[10, 9] <- 0.6
correlation_matrix[4, 10] <- correlation_matrix[10, 4] <- 0.5

# Generate correlated gene expression data
library(MASS)
expression_data <- mvrnorm(n = n_samples, 
                          mu = rep(5, n_genes), 
                          Sigma = correlation_matrix)

# Add some treatment effects
# Treatment A affects BRCA pathway
expression_data[11:20, 1:2] <- expression_data[11:20, 1:2] + 2
# Treatment B affects PI3K pathway
expression_data[21:30, c(4,9,10)] <- expression_data[21:30, c(4,9,10)] + 2.5

# Add some noise
expression_data <- expression_data + matrix(rnorm(n_genes*n_samples, sd=0.5), 
                                           nrow=n_samples, ncol=n_genes)

# Create a data frame
colnames(expression_data) <- gene_names
rownames(expression_data) <- sample_ids
expression_df <- as.data.frame(expression_data)
expression_df$Condition <- conditions

# Save the condition information separately
sample_annotation <- data.frame(
  Sample = sample_ids,
  Condition = conditions,
  row.names = "Sample"
)

# Calculate correlation matrix
gene_correlation <- cor(expression_data, method = "pearson")

# Plot correlation heatmap
pheatmap(gene_correlation,
         main = "Gene Expression Correlation Heatmap",
         color = colorRampPalette(rev(brewer.pal(11, "RdBu")))(50),
         breaks = seq(-1, 1, length.out = 51),
         display_numbers = FALSE,
         fontsize = 8,
         fontsize_row = 7,
         fontsize_col = 7,
         cluster_rows = TRUE,
         cluster_cols = TRUE)

# Principal Component Analysis
pca_result <- prcomp(expression_data, scale. = TRUE)
pca_df <- as.data.frame(pca_result$x[, 1:2])
pca_df$Condition <- conditions

# Plot PCA
ggplot(pca_df, aes(x = PC1, y = PC2, color = Condition)) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal() +
  labs(title = "PCA of Gene Expression Data",
       x = paste0("PC1 (", round(summary(pca_result)$importance[2,1]*100, 1), "%)"),
       y = paste0("PC2 (", round(summary(pca_result)$importance[2,2]*100, 1), "%)")) +
  theme(legend.position = "right")

# Differential expression analysis (simplified)
# Function to perform t-test for each gene between two conditions
perform_t_test <- function(data, condition_col, condition1, condition2) {
  genes <- setdiff(colnames(data), condition_col)
  results <- data.frame(
    Gene = character(),
    p_value = numeric(),
    fold_change = numeric(),
    stringsAsFactors = FALSE
  )
  
  for(gene in genes) {
    group1 <- data[data[[condition_col]] == condition1, gene]
    group2 <- data[data[[condition_col]] == condition2, gene]
    
    t_result <- t.test(group1, group2)
    fold_change <- mean(group2) / mean(group1)
    
    results <- rbind(results, data.frame(
      Gene = gene,
      p_value = t_result$p.value,
      fold_change = fold_change
    ))
  }
  
  # Adjust p-values for multiple testing
  results$adjusted_p <- p.adjust(results$p_value, method = "BH")
  return(results)
}

# Compare Treatment A vs Control
de_results_A <- perform_t_test(expression_df, "Condition", "Control", "Treatment A")
# Sort by p-value
de_results_A <- de_results_A[order(de_results_A$adjusted_p), ]
# Print top differentially expressed genes
cat("Top differentially expressed genes (Treatment A vs Control):\n")
print(head(de_results_A, 5))

# Compare Treatment B vs Control
de_results_B <- perform_t_test(expression_df, "Condition", "Control", "Treatment B")
# Sort by p-value
de_results_B <- de_results_B[order(de_results_B$adjusted_p), ]
# Print top differentially expressed genes
cat("\nTop differentially expressed genes (Treatment B vs Control):\n")
print(head(de_results_B, 5))

# Volcano plot for Treatment A vs Control
de_results_A$negLogP <- -log10(de_results_A$p_value)
de_results_A$log2FC <- log2(de_results_A$fold_change)
de_results_A$Significant <- de_results_A$adjusted_p < 0.05

ggplot(de_results_A, aes(x = log2FC, y = negLogP, color = Significant)) +
  geom_point(size = 2, alpha = 0.7) +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "grey")) +
  theme_minimal() +
  labs(title = "Volcano Plot - Treatment A vs Control",
       x = "log2 Fold Change",
       y = "-log10 p-value") +
  geom_text(data = subset(de_results_A, adjusted_p < 0.01),
            aes(label = Gene), vjust = -0.5, size = 3) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "blue") +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "blue")

# Print session information
sessionInfo() 