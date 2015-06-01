# VERSION 1.0
# DOCKER-VERSION  1.2.0
# AUTHOR:         Richard Lee <lifuzu@gmail.com>
# DESCRIPTION:    Image with nexus project and dependecies
# TO_BUILD:       $ sudo docker build -rm -t docker-nexus .
# TO_RUN:         $ sudo docker run -p 8081:8081 --name nexus docker-nexus

FROM ubuntu:14.04

MAINTAINER Richad Lee "lifuzu@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y curl
RUN apt-get install -y --no-install-recommends supervisor
RUN apt-get clean

# Java
RUN    cd /tmp && \ 
    curl -b gpw_e24=http%3A%2F%2Fwww.oracle.com -b oraclelicense=accept-securebackup-cookie -O -L http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-linux-x64.tar.gz && \
    tar -zxf /tmp/jdk-8u20-linux-x64.tar.gz -C /usr/local && \
    ln -s /usr/local/jdk1.8.0_20 /usr/local/java && \
    rm /tmp/jdk-8u20-linux-x64.tar.gz

# Enviroment
ENV    JAVA_HOME /usr/local/java
ENV    PATH $PATH:$JAVA_HOME/bin

# Nexus
RUN    cd /tmp && \
    curl -O -L http://www.sonatype.org/downloads/nexus-2.9.0-bundle.tar.gz && \
    tar -zxf nexus-2.9.0-bundle.tar.gz -C /opt && \
    mv /opt/nexus* /opt/nexus && \
    useradd nexus && \
    rm nexus-2.9.0-bundle.tar.gz

RUN     chown -R nexus /opt/sonatype-work && \
        chown -R nexus /opt/nexus

# Supervisor
RUN     mkdir -p /var/log/supervisor && mkdir -p /opt/supervisor
ADD     nexus.conf /etc/supervisor/conf.d/nexus.conf
ADD     nexus_supervisor /opt/supervisor/nexus_supervisor
RUN     chmod u+x /opt/supervisor/nexus_supervisor && chown nexus.nexus /opt/supervisor/nexus_supervisor

EXPOSE    8081

#USER    nexus

#VOLUME    ["/opt/sonatype-work", "/opt/nexus/conf"]

# Start Supervisor
CMD    /usr/bin/supervisord

