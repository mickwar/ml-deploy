### Fake data
set.seed(1)
n = 1000
k = 5
x = matrix(rnorm(n*k), n, k)
y = as.matrix(sin(x[,1]) + cos(pi * x[,2]) + x[,3]^2 - x[,4])

colnames(x) = paste0("x", 1:k)
colnames(y) = "y"

### Save the "raw" data
### In production, we would expect to only have raw x's (i.e. unprocessed features)
write.table(round(x, 3), "./raw_x.txt", quote = FALSE, row.names = FALSE)
write.table(round(y, 3), "./raw_y.txt", quote = FALSE, row.names = FALSE)
