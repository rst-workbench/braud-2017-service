FROM python:3.9

RUN apt-get update && \
    apt-get install -y python3-pip

COPY wait_for_it.py requirements.txt /opt/braud-2017-service/
COPY tests /opt/braud-2017-service/tests

WORKDIR /opt/braud-2017-service
RUN pip install -r requirements.txt


