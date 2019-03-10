#!/bin/bash

# Do "./run.py bg" to run in the background

if [ "$1" == "bg" ]; then
    # Run as a deamon (in the background)
    echo "Running gunicorn server in the background"
    echo "Do 'pkill gunicorn' to kill the process"
    gunicorn --bind 0.0.0.0:8000 --daemon server:app
else
    # Run in the foreground
    echo "Running gunicorn server in the foreground"
    gunicorn --bind 0.0.0.0:8000 server:app
fi
