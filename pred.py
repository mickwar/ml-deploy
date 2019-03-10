"""
    Script for sending data to the server to make predictions
"""

import pandas as pd
import json
import requests

# Run gunicorn from the terminal:
#   gunicorn --bind 0.0.0.0:8000 server:app

header = {'Content-Type': 'application/json', \
                  'Accept': 'application/json'}

test_x = pd.read_csv("data/test_x.txt", sep = ' ')


# Make the POST request to the server
resp = requests.post("http://0.0.0.0:8000/predict",
    data = json.dumps(test_x.to_json(orient = "records")),
    headers = header)


# Test set and predictions
pred_y = pd.read_json(resp.json()["predictions"], orient = "records")
test_y = pd.read_csv("data/test_y.txt", sep = ' ')

# MSE
print(pred_y)
print("")
print(sum((test_y.values - pred_y.values) ** 2) / len(test_y))
