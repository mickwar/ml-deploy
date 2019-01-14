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


### Save data
# Train
write.table(round(train_x, 3), "./train_x.txt", quote = FALSE, row.names = FALSE)
write.table(round(train_y, 3), "./train_y.txt", quote = FALSE, row.names = FALSE)

# Test
write.table(round(test_x, 3), "./test_x.txt", quote = FALSE, row.names = FALSE)
write.table(round(test_y, 3), "./test_y.txt", quote = FALSE, row.names = FALSE)
