#! /bin/sh

# This file is part of the DITA-OT Build GitHub Action project.
# See the accompanying LICENSE file for applicable licenses.

FROM ubuntu:20.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
    apt-get install -y --no-install-recommends openjdk-11-jre ant curl unzip git locales tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive locales tzdata && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

WORKDIR /opt/app/bin/
COPY entrypoint.sh entrypoint.sh
RUN chmod +x /opt/app/bin/entrypoint.sh

ENTRYPOINT ["/opt/app/bin/entrypoint.sh"]