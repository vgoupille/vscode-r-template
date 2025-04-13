import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris

# Load the Iris dataset
iris = load_iris()
iris_df = sns.load_dataset('iris')

# Set the style for better visualization
sns.set(style="whitegrid")

# Create a figure with multiple subplots
plt.figure(figsize=(15, 10))

# 1. Scatter plot of sepal length vs sepal width
plt.subplot(2, 2, 1)
sns.scatterplot(x='sepal_length', y='sepal_width', hue='species', data=iris_df)
plt.title('Sepal Length vs Sepal Width')

# 2. Scatter plot of petal length vs petal width
plt.subplot(2, 2, 2)
sns.scatterplot(x='petal_length', y='petal_width', hue='species', data=iris_df)
plt.title('Petal Length vs Petal Width')

# 3. Box plot of all features
plt.subplot(2, 2, 3)
sns.boxplot(data=iris_df.drop('species', axis=1))
plt.title('Box Plot of All Features')
plt.xticks(rotation=45)

# 4. Pair plot
plt.subplot(2, 2, 4)
sns.pairplot(iris_df, hue='species')
plt.suptitle('Iris Dataset Visualization', y=1.02)

# Adjust layout and show plot
plt.tight_layout()
plt.show()

# Additional: Correlation heatmap
plt.figure(figsize=(8, 6))
sns.heatmap(iris_df.drop('species', axis=1).corr(), annot=True, cmap='coolwarm')
plt.title('Correlation Heatmap')
plt.tight_layout()
plt.show() 