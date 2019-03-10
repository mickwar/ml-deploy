import numpy as np

### Generate fake data
# Seed and number of features
np.random.seed(0)
k = 5

# Fake train data
n = 1000
train_x = np.random.randn(n, k)
train_y = np.sin(train_x[:,0]) + np.cos(np.pi * train_x[:,1]) - train_x[:,2] ** 2 - train_x[:,3]

# Test set
m = 20
test_x = np.random.randn(m, k)
test_y = np.sin(test_x[:,0]) + np.cos(np.pi * test_x[:,1]) - test_x[:,2] ** 2 - test_x[:,3]

# Headers for data files
header_x = ' '.join(['x' + str(i) for i in range(1, 6)])
header_y = 'y'


### Save data
# Train
np.savetxt("data/train_x.txt", train_x, fmt = "%.3f", header = header_x, comments = '')
np.savetxt("data/train_y.txt", train_y, fmt = "%.3f", header = header_y, comments = '')

# Test
np.savetxt("data/test_x.txt", test_x, fmt = "%.3f", header = header_x, comments = '')
np.savetxt("data/test_y.txt", test_y, fmt = "%.3f", header = header_y, comments = '')

