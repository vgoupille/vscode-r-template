# Source: https://plotly.com/r/line-and-scatter/
library(plotly)

d <- diamonds[sample(nrow(diamonds), 1000), ]

fig <- plot_ly(
  d,
  x = ~carat, y = ~price,
  color = ~carat, size = ~carat,
  type = "scatter", mode = "markers"
)

# Display the figure explicitly when sourcing
print(fig)
