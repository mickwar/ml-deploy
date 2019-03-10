## Model deployment

This repository presents a simple example for deploying a machine learning model to a (local) server.
A server will load the model and wait for user input.
Data can be sent to the server with an [HTTP POST](https://en.wikipedia.org/wiki/POST_(HTTP)) request and model predictions will be returned.

Code for the server is written using [flask](http://flask.pocoo.org/), and the server is hosted using [gunicorn](https://gunicorn.org/).

[Docker](https://www.docker.com/) can be used as a sort of portable, lightweight hosting environment.
The Docker image used in this example uses Ubuntu installed with Python3 and contains the trained machine learning model.

Props to [this tutorial](https://www.analyticsvidhya.com/blog/2017/09/machine-learning-models-as-apis-using-flask/).

## Install the required packages

It is recommended to use a [virtual environment](https://virtualenv.pypa.io/en/latest/).

```bash
# bash
cd program                          # note: the virtual environment doesn't have to be in this directory
pip install virtualenv              # install virtualenv module
virtualenv env                      # initialize a virtual environment named env
source env/bin/activate             # activate the environment
pip install -r requirements.txt     # install the required packages of this example to the environment
pip list                            # view list of installed packages
```

(Note that the virtual environment can be named whatever, but the local `.gitignore` will exclude the `.env` directory.)

When within the virtual environment, packages were installed via `pip install`. But when the environment is set up as desired, future intializations are completed using the [requirements.txt](program/requirements.txt) file as above.

The `requirements.txt` file was generated with
```bash
pip freeze > requirements.txt
```
while within the virtual environment. The command `pip freeze` takes a snapshot of the currently installed modules and their version numbers.

The virtual environment is activated with
```bash
source env/bin/activate
```
and will prepend the shell prompt to include `(env)`.

The virtual environment can be deactivated simply with
```bash
deactivate
```

The remainder of this example expects the user to have the virtual environment activated with the packages listed under `requirements.txt` installed.
The Docker image does not use the virtual environment, instead the packages are installed globally (for the image).

## Get the server ready

Generating fake data, training a linear model, and spinning up the server can be done using the bash scripts inside `program`.

```bash
cd program      # This is necessary to execute setup.sh and run.sh
./setup.sh      # generate data, fit the model
./run.sh bg     # start the server in the background
```

These two scripts are simply wrapper functions for the process described in the next three subsections.

### Generate data

Execute the [gen_data.py](data/gen_data.py) script

```bash
python data/gen_data.py
```

This will create four files:
- `data/train_x.txt`
- `data/train_y.txt`
- `data/test_x.txt`
- `data/test_y.txt`

### Fit a model

Execute the [lm_train.py](model/lm_train.py) script to fit a linear model to the training data.
Note that this will be a bad model since the response is fairly non-linear.
```bash
python model/lm_train.py
```

The model will be saved to `model/lm_mod.pickle` using [pickle](https://docs.python.org/3/library/pickle.html).


### Run the server

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

With the server up and running---listening on `0.0.0.0:8000`---we are ready to send data to the server.

Technically, anything that lets you make a POST request---accompanied with some properly formatted JSON data---would be an acceptable way of communicating with the server.
For this example, we can use the [pred.py](pred.py) script.

The `pred.py` script sends the test data (in JSON format) to the server via the `/predict` endpoint.
The data is processed within `server.apicall()` and the predictions are sent back as JSON to the user.
Notice that some conversion between JSON and numpy array is done since the model expects a numpy array, but the HTTP request expects JSON.

It may be most helpful to play with `pred.py` interactively, but running
```bash
python pred.py
```
is also acceptable.
You should see a table print out for the predicted values, followed by the MSE:

```
           0
0  -0.155496
1   0.098487
2   2.130050
3  -2.077463
4   2.562407
5  -0.085750
6  -0.352975
7  -1.987332
8  -0.351220
9   0.951248
10 -1.636224
11 -3.547744
12 -1.239803
13 -0.666220
14 -0.059957
15 -1.367055
16  0.370481
17 -1.266943
18 -0.540817
19 -2.843020

[2.09111105]
```


## Docker

#### Preliminaries

[Install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

[Use Docker without sudo](https://docs.docker.com/install/linux/linux-postinstall/)


#### Set up

Build the Docker image with

```bash
./build_docker.sh
```

This may take a minute or two since the base Ubuntu image will be pulled from [Docker Hub](http://hub.docker.com) and Python3 will have to be installed on the image.

Once the image is built, you are ready to run a container (something like a temporary copy of Docker image).
Run the container with

```bash
docker run -p 8181:8000 ml-deploy
```

The `8181` is the port that the host will listen on, meaning we will send requests to `8181` (note the commented out section in `pred.py`).
The `8000` is the port used internally by the Docker container for the gunicorn server.
And `ml-deploy` is the name of the image created from the `build_docker.sh` script.

At this point, you can use the `pred.py` script again to send requests to the container.
As noted earlier, the container listens on port `8181`, so that change would need to be accounted for when running `pred.py`.

To run the container interactively, comment out the ENTRYPOINT line in the `dockerfile` when building the image.
This shouldn't really be the case, but I couldn't figure out how to be able to run the container normally and also have access to it interactively.
Running the container interactively puts you in a shell for the container.
You can do whatever you want, such as installing packages or running some Python code.
But after the container is stopped, no changes are saved (recall the temporary nature of Docker containers).


### Useful Docker commands

command                     | description
-------                     | -----------
`docker build -t <tag> .`   | build an image from a dockerfile (found in current directory)
`docker run -it <image>`    | run <image> interactively (opens bash, at least on my system when running on a base Ubuntu image)
`docker images`             | list images
`docker image rm <image>`   | remove <image>
`docker image prune`        | remove unused (including intermediary) images
`docker ps`                 | list containers (`-a` to show all, including stopped)
`docker container prune`    | remove all stopped containers
