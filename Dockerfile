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

RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer

RUN wget -O /minecraft/minecraft.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar    
RUN pip install -r requirements.txt

VOLUME ["/var/lib/minecraft"]

RUN apt-get remove -y \
  build-essential wget curl

EXPOSE 25565

CMD ["/usr/bin/mark2","start","/var/lib/minecraft"]
