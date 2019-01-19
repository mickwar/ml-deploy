## Model deployment

This repository presents a simple example for deploying a machine learning model to a (local) server.
A server will load the model and wait for user input.
Data can be sent to the server with an [HTTP POST](https://en.wikipedia.org/wiki/POST_(HTTP)) and model predictions will be returned.

Code for the server is written using [flask](http://flask.pocoo.org/), and the server is hosted using [gunicorn](https://gunicorn.org/).

Props to [this tutorial](https://www.analyticsvidhya.com/blog/2017/09/machine-learning-models-as-apis-using-flask/).


## Install the required packages

It is recommended to use a [virtual environment](https://virtualenv.pypa.io/en/latest/).

```bash
# bash
pip install virtualenv
virtualenv my_env                 # initialize a virtual environment
source my_env/bin/activate        # activate the environment
pip install -r requirements.txt   # install the required packages of this repository to the environment
pip list                          # view list of installed packages
```

When within the virtual environment, packages were installed via `pip install`. But when the environment is set up as desired, future intializations are completed using the [requirements.txt](./requirements.txt) file as above.

The `requirements.txt` file was generated with
```bash
pip freeze > requirements.txt
```
while within the virtual environment. The command `pip freeze` takes a snapshot of the current modules and their version numbers.

The virtual environment is activated with
```bash
source my_env/bin/activate
```
and will prepend the prompt to include `(my_env)`.

The virtual environment can be deactivated simply with
```bash
deactivate
```

## Generate data

Execute the [gen_data.py](data/gen_data.py) script

```bash
python data/gen_data.py
```

This will create four files:
- `data/train_x.txt`
- `data/train_y.txt`
- `data/test_x.txt`
- `data/test_y.txt`

## Fit a model

Execute the [lm_train.py](model/lm_train.py) script to fit a linear model to the training data.
Note that this will be a bad model since the response is fairly non-linear.
```bash
python model/lm_train.py
```

The model will be saved to `model/lm_mod.pickle` using [pickle](https://docs.python.org/3/library/pickle.html).


## Run the server

Start hosting the server with
```bash
gunicorn --bind 0.0.0.0:8000 --daemon server:app
```
This will run the run the flask app (called `app`) found in `server.py` and can be accessed at `http://0.0.0.0:8000`.
The app itself only has one endpoint `/predict` and expects a POST method.
So, if you go to `http://0.0.0.0:8000/predict` in your browser, you'll receive an error saying the method is not allowed (the method in this case would be the GET method).

When running gunicorn in the background (i.e. as a daemon), the process can be killed with
```bash
pkill gunicorn
```

## Make predictions

The [pred.py](pred.py) script sends the test data (in JSON format) to the server via the `/predict` endpoint.
The data is processed within `server.apicall()` and the predictions (as JSON) are sent back to the user.

It may be most convenient play with `pred.py` interactively.
