FROM apache/airflow:2.6.1

ARG CURRENT_USER=$USER

USER root
# Install Python dependencies to be able to process the wheels from the private PyPI server.
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y python3.9-distutils python3.9-dev build-essential git

# Install librdkafka
RUN apt-get install -y build-essential liblz4-dev libssl-dev zlib1g-dev libsasl2-dev
RUN git clone https://github.com/edenhill/librdkafka.git && \
    cd librdkafka && \
    git checkout v1.9.0 && \
    ./configure --prefix=/usr && \
    make && \
    make install

# Create output directory and change ownership
RUN mkdir -p /opt/output && chown ${CURRENT_USER}:${CURRENT_USER} /opt/output

USER ${CURRENT_USER}
