FROM ubuntu:13.04
MAINTAINER Paulson McIntyre, paul+mark2docker@gpmidi.net

RUN useradd -m mcservers

# Do an initial update
RUN apt-get update
RUN apt-get dist-upgrade -y

# Stuff pip will require
RUN apt-get install -y \
  build-essential git python python-dev \
  python-setuptools python-pip wget curl \
  openjdk-7-jre-headless curl rdiff-backup \
  python-openssl libssl-dev \
  supervisor logrotate cron

RUN mkdir -p /var/log/supervisord && \
  chmod 700 /var/log/supervisord/

# Daemons to run
ADD ./supervisord.d/ /etc/supervisor/conf.d/

# Log rotate config
ADD ./logrotate.d/supervisord.conf /etc/logrotate.d/supervisord.conf

VOLUME ["/var/lib/minecraft","/etc/mark2"]

ADD ./ /var/lib/minecraft/    
RUN chmod +x /var/lib/minecraft/mark2 \
  && mkdir /etc/mark2 \
  && chmod -R 755 /var/lib/minecraft/ \
  && cp -a /var/lib/minecraft/mc-main/ /etc/mark2/
  && chmod -R 755 /etc/mark2
  
RUN wget -O /var/lib/minecraft/minecraft.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar

RUN pip install -r /var/lib/minecraft/requirements.txt
RUN ln -s /var/lib/minecraft/mark2 /usr/bin/mark2

# Basic SSHd setup
RUN apt-get -yq install openssh-server vim \
  && mkdir -p /var/run/sshd \
  && chmod 755 /var/run/sshd \
  && mkdir /root/.ssh \
  && chmod 700 /root/.ssh \
  && echo "Done with SSHd debug S&C"

ADD ./authorized_keys /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys && chown root:root /root/.ssh/authorized_keys

RUN chown -R mcservers:mcservers /var/lib/minecraft \
  && chmod -R 755 /var/lib/minecraft

#RUN apt-get remove -y \
#  build-essential openssh-server vim

EXPOSE 25565

CMD ["supervisord", "--nodaemon", "--logfile=/var/log/supervisord/supervisord.log", "--loglevel=warn", "--logfile_maxbytes=1GB", "--logfile_backups=0"]

