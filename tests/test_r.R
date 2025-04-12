# Basic R test script for bioinformatics
# This script demonstrates basic R functionality and some bioinformatics operations

# Load required libraries (if not installed, you'll need to install them first)
# install.packages(c("ggplot2", "dplyr"))
library(ggplot2)
library(dplyr)

# Create some example biological data
# Simulating gene expression data for 5 genes across 10 samples
set.seed(123)  # For reproducibility
gene_names <- c("BRCA1", "TP53", "EGFR", "KRAS", "PTEN")
sample_ids <- paste0("Sample_", 1:10)

# Generate random expression values
expression_data <- matrix(rnorm(50, mean = 5, sd = 2), 
                         nrow = 5, 
                         ncol = 10, 
                         dimnames = list(gene_names, sample_ids))

# Convert to data frame for easier manipulation
expression_df <- as.data.frame(t(expression_data))
expression_df$SampleID <- sample_ids

# Basic statistics
summary(expression_df)

# Calculate mean expression per gene
gene_means <- colMeans(expression_df[, gene_names])
print(gene_means)

# Simple visualization
# Convert to long format for ggplot
expression_long <- expression_df %>%
  tidyr::pivot_longer(cols = all_of(gene_names), 
                     names_to = "Gene", 
                     values_to = "Expression")

# Create a boxplot of gene expression
p <- ggplot(expression_long, aes(x = Gene, y = Expression, fill = Gene)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Gene Expression Distribution",
       x = "Gene",
       y = "Expression Level") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Display the plot
print(p)

# Perform a t-test to compare expression of two genes
t_test_result <- t.test(expression_df$BRCA1, expression_df$TP53)
print(t_test_result)

# Save results
# write.csv(expression_df, "expression_data.csv")
# ggsave("gene_expression_boxplot.png", p, width = 8, height = 6)

# Print session info
sessionInfo() 