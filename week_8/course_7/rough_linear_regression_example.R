# rough_linear_regression_example.R

# Import library  
library(caTools)

# Import dataset
dataset <- read.csv('./dataset/GamePoints_Data.csv')

# Split dataset into training-set and test-set.
set.seed(123)
split <- sample.split(dataset$GamePoints, SplitRatio = 0.8)
training_set <- subset(dataset, split == TRUE)
test_set <- subset(dataset, split == FALSE)

# Feature Scale(if needed, check https://goo.gl/2mQumZ for this concept.)
# training_set <- scale(training_set)
# test_set <- scale(test_set)

# Build model: fit linear regression to training_set
regressor <- lm(formula = GamePoints ~ PlayingHours,
               data = training_set)

# Predict the test_set results
y_pred <- predict(regressor, newdata = test_set)

# Visualize the training_set results
library(ggplot2)
ggplot() +
  geom_point(aes(x = training_set$PlayingHours, y = training_set$GamePoints),
             colour = 'red') +
  geom_line(aes(x = training_set$PlayingHours, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('GamePoints vs PlayingHours (Training set)') +
  xlab('Hours of playing') +
  ylab('GamePoints')

# Visualize the test_set results
library(ggplot2)
ggplot() +
  geom_point(aes(x = test_set$PlayingHours, y = test_set$GamePoints),
             colour = 'red') +
  geom_line(aes(x = training_set$PlayingHours, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('GamePoints vs PlayingHours (Test set)') +
  xlab('Hours of playing') +
  ylab('GamePoints')