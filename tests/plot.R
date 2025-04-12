library(ggplot2)

data(diamonds)

head(diamonds)

View(diamonds)

d <- diamonds[sample(nrow(diamonds), 2000), ]


a <- ggplot(data = d, aes(
        x = carat,
        y = price,
        col = carat,
        size = carat
)) +
        geom_point() +
        theme(text = element_text(family = "Latin Modern Roman"))


b <- ggplot(data = d, aes(
        x = carat,
        y = price,
        col = cut,
        size = carat
)) +
        geom_point() +
        theme(text = element_text(family = "Latin Modern Roman"))

c <- ggplot(data = d, aes(
        x = carat,
        y = price,
        col = cut
)) +
        geom_point() +
        theme(text = element_text(family = "Latin Modern Roman"))

print(a)
print(b)
print(c)

ggplot2::theme_get()$text$family

# Définir une police par défaut pour ggplot2
if (requireNamespace("ggplot2", quietly = TRUE)) {
        ggplot2::theme_update(text = ggplot2::element_text(family = "Latin Modern Roman"))
}
