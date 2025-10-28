#! /bin/sh

# This file is part of the DITA-OT Build GitHub Action project.
# See the accompanying LICENSE file for applicable licenses.

FROM debian:12.11-slim AS dita-ot
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:21 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ENV DITA_HOME=/opt/app
ENV PATH=${PATH}:${DITA_HOME}/bin
COPY --from=ghcr.io/dita-ot/dita-ot:4.3.5 $DITA_HOME $DITA_HOME

USER root
WORKDIR /

COPY entrypoint.sh entrypoint.sh
COPY script.sh install_script.sh
COPY script.sh build_script.sh

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --reinstall tzdata && \
    apt-get install -y locales && \
    apt-get install -y curl && \
    apt-get install -y unzip && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive locales tzdata && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entrypoint.sh && \
    chmod +x /build_script.sh && \
    chmod +x /install_script.sh

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

ENTRYPOINT ["/entrypoint.sh"]
