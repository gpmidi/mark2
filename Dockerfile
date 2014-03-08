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
  openssh-server python-openssl libssl-dev


#RUN wget -O /minecraft/minecraft.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar

VOLUME ["/var/lib/minecraft"]

ADD ./ /var/lib/minecraft/    
RUN pip install -r /var/lib/minecraft/requirements.txt
RUN ln -s /var/lib/minecraft/mark2 /usr/bin/mark2

RUN apt-get remove -y \
  build-essential wget curl

EXPOSE 25565

CMD ["/usr/bin/mark2","start","/var/lib/minecraft"]
