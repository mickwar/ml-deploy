#!/bin/bash

# Run this script while the virtual environment is activated
# The script will
#   1. generate the fake data,
#   2. train a linear model,
#   3. and spin up a server listening on 0.0.0.0:8000

python data/gen_data.py
python model/lm_train.py
gunicorn --bind 0.0.0.0:8000 server:app
