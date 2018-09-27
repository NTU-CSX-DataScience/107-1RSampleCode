library(ggplot2)

iris

View(iris)

temp = data.frame(matrix(unlist(data), nrow=150, byrow = T))
ggplot( data = i, aes( x = Species ) ) + 
  geom_bar(fill = "lightblue", colour = "black")
