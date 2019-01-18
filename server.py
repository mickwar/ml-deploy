import pickle
import pandas as pd
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/predict", methods = ["POST"])
def apicall():
    # Read in data
    try:
        # Read in data with pandas (for the JSON support)
        test_x = pd.read_json(request.get_json())
    except:
        pass

    # Make predictions if data is not empty
    if test_x.empty:
        return (1)
    else:
        # Convert data to numpy array (expected by the model)
        test_x = test_x.values

        # Load model
        with open("model/lm_mod.pickle") as f:
            mod = pickle.load(f)

        # Make predictions (returns a numpy array)
        pred_y = mod.predict(test_x)

        # Convert back to pd.DataFrame and then to a JSON
        pred_y = pd.DataFrame(pred_y).to_json(orient = "records")

        response = jsonify(predictions = pred_y)
        response.status_code = 200

        return (response)
