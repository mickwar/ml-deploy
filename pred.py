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

test_x = pd.read_csv("program/data/test_x.txt", sep = ' ')


# Make the POST request to the server
# When testing without Docker
resp = requests.post("http://0.0.0.0:8000/predict",
    data = json.dumps(test_x.to_json(orient = "records")),
    headers = header)

# When testing with Docker (assuming the address binding was 8181:8000)
#resp = requests.post("http://0.0.0.0:8181/predict",
#    data = json.dumps(test_x.to_json(orient = "records")),
#    headers = header)


# Test set and predictions
pred_y = pd.read_json(resp.json()["predictions"], orient = "records")
test_y = pd.read_csv("program/data/test_y.txt", sep = ' ')

# MSE
print(pred_y)
print("")
print(sum((test_y.values - pred_y.values) ** 2) / len(test_y))
