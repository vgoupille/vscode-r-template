import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import pandas as pd
import numpy as np
from sklearn.datasets import load_iris

# Load the Iris dataset
iris = load_iris()
iris_df = pd.DataFrame(iris.data, columns=iris.feature_names)
iris_df['species'] = [iris.target_names[i] for i in iris.target]
iris_df['species_num'] = iris.target  # Add numeric species column

# Create a 3D scatter plot
fig_3d = px.scatter_3d(iris_df, 
                      x='sepal length (cm)', 
                      y='sepal width (cm)', 
                      z='petal length (cm)',
                      color='species',
                      title='3D Visualization of Iris Dataset')

# Create a parallel coordinates plot
fig_parallel = px.parallel_coordinates(iris_df, 
                                     dimensions=['sepal length (cm)', 'sepal width (cm)',
                                               'petal length (cm)', 'petal width (cm)'],
                                     color='species_num',
                                     color_continuous_scale=px.colors.qualitative.Set1,
                                     title='Parallel Coordinates Plot of Iris Features')

# Create a violin plot
fig_violin = px.violin(iris_df, 
                      y=['sepal length (cm)', 'sepal width (cm)', 
                         'petal length (cm)', 'petal width (cm)'],
                      color='species',
                      title='Violin Plot of Iris Features')

# Create a correlation heatmap
corr_matrix = iris_df.drop(['species', 'species_num'], axis=1).corr()
fig_heatmap = go.Figure(data=go.Heatmap(
    z=corr_matrix.values,
    x=corr_matrix.columns,
    y=corr_matrix.columns,
    colorscale='RdBu',
    zmin=-1,
    zmax=1
))
fig_heatmap.update_layout(title='Correlation Heatmap of Iris Features')

# Create a scatter matrix
fig_scatter = px.scatter_matrix(iris_df,
                              dimensions=['sepal length (cm)', 'sepal width (cm)',
                                        'petal length (cm)', 'petal width (cm)'],
                              color='species',
                              title='Scatter Matrix of Iris Features')

# Show all plots
fig_3d.show()
fig_parallel.show()
fig_violin.show()
fig_heatmap.show()
fig_scatter.show() 