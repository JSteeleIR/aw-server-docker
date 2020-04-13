FROM debian:buster-slim

LABEL maintainer="Jacob Steele <jsteele@jsteeleir.com>"
LABEL repository="https://github.com/jsteeleir/aw-server-docker"

RUN mkdir /aw-server
WORKDIR /aw-server

RUN apt-get -qq -y update \
  && apt-get install -qq -y --no-install-recommends ca-certificates unzip build-essential git nodejs npm python3 python3-pip python3-venv


RUN /usr/bin/pip3 install --upgrade setuptools wheel \
  && /usr/bin/pip3 install poetry pipenv \
  && /usr/bin/npm install -g npm@latest

VOLUME ["/aw-server-data/"]

RUN git clone --recursive https://github.com/ActivityWatch/aw-server.git /aw-server \
  && cd /aw-server \
  && pipenv --three \
  && pipenv run make build \
  && mkdir -p /root/.local/share/activitywatch/ \
  && ln -s /aw-server-data /root/.local/share/activitywatch/aw-server


EXPOSE 5600
#ENTRYPOINT ["/bin/bash", "-c"]
ENTRYPOINT ["/usr/local/bin/pipenv","run"]
CMD ["aw-server", "--host", "0.0.0.0"]
