#! /bin/sh

# This file is part of the DITA-OT Build GitHub Action project.
# See the accompanying LICENSE file for applicable licenses.

FROM --platform=$BUILDPLATFORM ghcr.io/dita-ot/dita-ot:4.3.3 AS DITA_OT
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root
WORKDIR /

COPY entrypoint.sh entrypoint.sh
COPY script.sh install_script.sh
COPY script.sh build_script.sh

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install --reinstall tzdata && \
	ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive locales tzdata && \
	locale-gen en_US.UTF-8 && \
	rm -rf /var/lib/apt/lists/* && \
	chmod +x /entrypoint.sh && \
	chmod +x /build_script.sh  && \
	chmod +x /install_script.sh

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

ENTRYPOINT ["/entrypoint.sh"]
