FROM ubuntu:13.04
MAINTAINER Paulson McIntyre, paul+mark2docker@gpmidi.net

RUN useradd -m mcservers
RUN mkdir -p /var/lib/minecraft && chown mcservers:mcservers /var/lib/minecraft && chmod 755 /var/lib/minecraft

# Do an initial update
RUN apt-get update
RUN apt-get -y upgrade --no-install-recommends

# Stuff pip will require
RUN apt-get install -y \
  build-essential git python python-dev \
  python-setuptools python-pip wget curl \
    
RUN pip install -r requirements.txt

RUN apt-get remove -y \
  build-essential wget curl

EXPOSE 25565

CMD ["/usr/bin/mark2","start","/var/lib/minecraft"]
