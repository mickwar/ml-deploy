FROM ubuntu:18.04

# Get python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip

# # Make aliases
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

# Install the required python modules
# No need for a virtual environment here
COPY program/ /opt/program/
WORKDIR /opt/program/
RUN pip install setuptools wheel -r requirements.txt

# Some environment variables to optimize python
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE

# Set up the container to have the training data and the trained model
# (Normally, the model would be trained outside of the container, but this
# example is very cheap to run so it's not a big deal)
RUN ./setup.sh

# On container start up, run the command that starts the gunicorn server
ENTRYPOINT ["./run.sh", "fg"]
