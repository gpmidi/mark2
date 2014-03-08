FROM ubuntu:13.04
MAINTAINER Paulson McIntyre, paul+mark2docker@gpmidi.net

RUN useradd -m mcservers
RUN mkdir -p /var/lib/minecraft && chown mcservers:mcservers /var/lib/minecraft && chmod 755 /var/lib/minecraft

# Do an initial update
RUN apt-get update
RUN apt-get dist-upgrade -y

# Stuff pip will require
RUN apt-get install -y \
  build-essential git python python-dev \
  python-setuptools python-pip wget curl \
  openjdk-7-jre-headless curl rdiff-backup \
  openssh-server


#RUN wget -O /minecraft/minecraft.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar    
RUN pip install -r requirements.txt

VOLUME ["/var/lib/minecraft"]

RUN apt-get remove -y \
  build-essential wget curl

EXPOSE 25565

CMD ["/usr/bin/mark2","start","/var/lib/minecraft"]
