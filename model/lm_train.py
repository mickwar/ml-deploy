# Train and save a linear model
import pickle
from sklearn import linear_model
from numpy import loadtxt

# Load training data
train_x = loadtxt("../data/train_x.txt", skiprows = 1)
train_y = loadtxt("../data/train_y.txt", skiprows = 1)

# Fit a linear regression model
mod = linear_model.LinearRegression()
mod.fit(train_x, train_y)

# Output the model with pickle
with open("lm_mod.pickle", "wb") as f:
    pickle.dump(mod, f)

