#!/bin/bash

# Run this script while the virtual environment is activated
# The script will
#   1. generate the fake data
#   2. and train a linear model

# Make sure the script is run from program/ directory
if [ `basename $PWD` == "program" ]; then
    python data/gen_data.py
    python model/lm_train.py
else
    echo "setup.sh should be run from within the program/ directory"
fi
