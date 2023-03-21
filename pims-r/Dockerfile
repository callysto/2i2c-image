ARG BASE_CONTAINER=callysto/2i2c-notebook:latest
FROM $BASE_CONTAINER
LABEL maintainer="Ian Allison <iana@pims.math.ca>"

USER root

ENV SHELL /bin/bash
RUN useradd -m -s /bin/bash -N -u 9999 jupyter
USER jupyter
ENV NB_USER=jupyter \
    NB_UID=9999
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/ \
    HOME=/home/$NB_USER
HEALTHCHECK --interval=120s --timeout=60s --start-period=30s --retries=3 \
    CMD /etc/jupyter/docker_healthcheck.py || exit 1
WORKDIR "${HOME}"
