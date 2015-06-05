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
    curl -O -L https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-latest-bundle.tar.gz && \
    tar -zxf nexus-latest-bundle.tar.gz -C /opt && \
    mv /opt/nexus* /opt/nexus && \
    useradd nexus && \
    rm nexus-latest-bundle.tar.gz

RUN     chown -R nexus /opt/sonatype-work && \
        chown -R nexus /opt/nexus


EXPOSE    8081

#USER    nexus

#VOLUME    ["/opt/sonatype-work", "/opt/nexus/conf"]

# Start Nexus
CMD    /opt/nexus/bin/nexus start

