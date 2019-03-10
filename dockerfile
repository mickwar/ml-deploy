FROM ubuntu:18.04

# Get python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip

# # Make aliases
# RUN alias python=python3
# RUN alias pip=pip3

# Install the required python modules
COPY requirements.txt /opt/program/
RUN pip3 install setuptools wheel -r /opt/program/requirements.txt

# Some environment variables to optimize python
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE

#ENTRYPOINT["python3", "serve"]
