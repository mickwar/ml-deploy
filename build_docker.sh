#!/bin/bash

docker build -t ml-deploy .


# The 8181 is the port that the host will listen on, meaning we will send
# requests to 8181. The 8000 is the port used internally by the docker for the
# gunicorn server.
#docker run -p 8181:8000 ml-deploy
