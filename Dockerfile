#! /bin/sh

# This file is part of the DITA-OT Build GitHub Action project.
# See the accompanying LICENSE file for applicable licenses.

#FROM ghcr.io/dita-ot/dita-ot/dita-ot:3.6 AS DITA_OT
FROM ubuntu:20.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DITA_HOME=/opt/app
ENV PATH=${PATH}:${DITA_HOME}/bin 

COPY entrypoint.sh entrypoint.sh
COPY script.sh install_script.sh
COPY script.sh build_script.sh

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
    apt-get install -y --no-install-recommends openjdk-11-jre ant curl unzip git locales tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive locales tzdata && \
	locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entrypoint.sh && \
	chmod +x /build_script.sh  && \
	chmod +x /install_script.sh

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

#COPY --from=DITA_OT /opt/app /opt/app
RUN curl -sLo /tmp/dita-ot-3.6.zip https://github.com/dita-ot/dita-ot/releases/download/3.6/dita-ot-3.6.zip && \
    unzip -qq /tmp/dita-ot-3.6.zip -d /tmp/ && \
    rm /tmp/dita-ot-3.6.zip && \
    mkdir -p /opt/app/ && \
    mv /tmp/dita-ot-3.6/bin /opt/app/bin && \
    chmod 755 /opt/app/bin/dita && \
    mv /tmp/dita-ot-3.6/config /opt/app/config && \
    mv /tmp/dita-ot-3.6/lib /opt/app/lib && \
    mv /tmp/dita-ot-3.6/plugins /opt/app/plugins && \
    mv /tmp/dita-ot-3.6/build.xml /opt/app/build.xml && \
    mv /tmp/dita-ot-3.6/integrator.xml /opt/app/integrator.xml && \
    rm -r /tmp/dita-ot-3.6 && \
    /opt/app/bin/dita --install


ENTRYPOINT ["/entrypoint.sh"]