ARG BASE_CONTAINER=jupyter/scipy-notebook:latest
FROM $BASE_CONTAINER
ENV NB_PYTHON_PREFIX=${CONDA_DIR}

# Install pip packages

USER root
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  dvipng \
  fonts-dejavu \
  python-dev \
  hdf5-tools \
  libhdf5-103 \
  libgmp-dev \
  libmpfr-dev \
  libzmq5 \
  libzmq5-dev \
  libssl-dev \
  less openssh-client zip \
  man git libxrender1 \
  pyqt5-dev-tools \
  gnupg procps tzdata vim && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /bin/tar /bin/gtar


RUN mkdir -p /etc/jupyter
COPY ./jupyter_notebook_config.py /etc/jupyter/

USER ${NB_UID}

COPY conda-linux-64.lock /tmp/conda-linux-64.lock
RUN mamba update --quiet --file /tmp/conda-linux-64.lock && \
    mamba clean --all -y -f && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY pip.conf /etc/pip.conf
COPY requirements.txt /tmp/requirements.txt
RUN echo "Installing python packages using pip from requirements.txt..." \
    && ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /tmp
RUN jupyter nbextension install --py callystonb --sys-prefix && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_UID}

WORKDIR "${HOME}"

ENV SHELL /bin/bash

USER ${NB_UID}
