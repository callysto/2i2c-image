ARG BASE_CONTAINER=pimsubc/pims-syzygy:latest
FROM $BASE_CONTAINER
LABEL maintainer="Ian Allison <iana@pims.math.ca>"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-freefont-otf \
    gnuplot \
    pstoedit \
    epstool \
    default-jre-headless \
    libopenblas0 \
    libatlas3-base \
    openmpi-bin \
    libopenmpi-dev \
    m4 \
    yasm \
    libacl1-dev \
    gettext \
    gfortran \
    gcc \
    g++ \
    zlib1g-dev \
    libffi-dev \
    libmetis-dev \
    libpng-dev \
    libpixman-1-dev \
    libpoppler-dev \
    librsvg2-dev \
    libcairo2-dev \
    libpango1.0-0 \
    tk-dev \
    pkg-config && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ENV NB_UID="1000"\
    NB_GID="100" \
    NB_USER="jovyan" \
    HOME="/home/jovyan"

RUN mamba install --quiet \
    octave \
    octave_kernel && \
    mamba clean --all -y -f && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN octave --eval "pkg install -forge symbolic"
COPY --chown=${NB_USER}:${NB_GID} octave-packages.m /tmp/octave-packages.m
RUN /opt/conda/bin/octave-cli /tmp/octave-packages.m

USER jupyter
ENV NB_USER=jupyter \
    NB_UID=9999
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/ \
    HOME=/home/$NB_USER

WORKDIR "${HOME}"
