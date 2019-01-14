### Fake training data
set.seed(1)
n = 1000
k = 5
train_x = matrix(rnorm(n*k), n, k)
train_y = as.matrix(sin(train_x[,1]) + cos(pi * train_x[,2]) + train_x[,3]^2 - train_x[,4])

colnames(train_x) = paste0("x", 1:k)
colnames(train_y) = "y"


### Fake testing data
m = 20
test_x = matrix(rnorm(m*k), m, k)
test_y = as.matrix(sin(test_x[,1]) + cos(pi * test_x[,2]) + test_x[,3]^2 - test_x[,4])

colnames(test_x) = paste0("x", 1:k)
colnames(test_y) = "y"


### Save the "raw" training data
write.table(round(train_x, 3), "./raw_train_x.txt", quote = FALSE, row.names = FALSE)
write.table(round(train_y, 3), "./raw_train_y.txt", quote = FALSE, row.names = FALSE)

### In production, we would expect to only have raw x's (i.e. unprocessed features),
### but we use test_y so we can validate our model
write.table(round(test_x, 3), "./raw_test_x.txt", quote = FALSE, row.names = FALSE)
write.table(round(test_y, 3), "./raw_test_y.txt", quote = FALSE, row.names = FALSE)
