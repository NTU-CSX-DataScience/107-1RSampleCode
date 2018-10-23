# rough_linear_regression_example.R

# Import library  
library(e1071)

# Importing the dataset
data(iris)

# Create x and y
x <- subset(iris, select = -Species)
y <- iris$Species

# Build model
model <- svm(Species ~ ., data = iris)

# Predict with the model
pred_result <- predict(model, x)

# View and visualize the result
table(pred_result, y)

plot(model, iris, Petal.Width ~ Petal.Length,
     slice = list(Sepal.Width = 3, Sepal.Length = 4),color.palette = terrain.colors)

plot(model, iris, Sepal.Width ~ Petal.Width,
     slice = list(Sepal.Length = 3, Petal.Length = 4),color.palette = terrain.colors)
