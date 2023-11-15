ARG BASE_CONTAINER=jupyter/minimal-notebook:latest
FROM $BASE_CONTAINER
ENV NB_PYTHON_PREFIX=${CONDA_DIR}

LABEL maintainer="Callysto Project contact@callysto.ca"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root
RUN apt-get update && apt-get install -y \
  build-essential \
  cm-super \
  curl \
  dvipng \
  ffmpeg \
  fonts-dejavu \
  python3-dev \
  hdf5-tools \
  libcairo2-dev \
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

RUN echo "c.NotebookApp.show_banner = False" >> /etc/jupyter/jupyter_notebook_config.py && \
  echo "c.ServerApp.show_banner = False" >> /etc/jupyter/jupyter_server_config.py && \
  echo "c.ServerApp.default_url = '/tree'" >> /etc/jupyter/jupyter_server_config.py && \
  fix-permissions /etc/jupyter

USER ${NB_UID}

RUN mkdir -p /opt/conda/share/jupyter/lab/settings && \
  chown ${NB_USER}:${NB_GID} /opt/conda/share/jupyter/lab
COPY --chown=${NB_USER}:${NB_GID} jupyterlab-overrides.json \
  /opt/conda/share/jupyter/lab/settings/overrides.json

COPY --chown=${NB_USER}:${NB_GID} conda-linux-64.lock /tmp/conda-linux-64.lock
RUN mamba update --quiet --file /tmp/conda-linux-64.lock && \
    mamba clean --all -y -f && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY --chown=${NB_USER}:${NB_GID} pip.conf /etc/pip.conf
COPY --chown=${NB_USER}:${NB_GID} requirements.txt /tmp/requirements.txt
RUN echo "Installing python packages using pip from requirements.txt..." \
    && ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /tmp
# Install facets which does not have a pip or conda package at the moment
# Also add qgrid extension because conda package is currently broken
RUN git clone https://github.com/PAIR-code/facets.git && \
    jupyter-nbclassic-extension install facets/facets-dist/ --sys-prefix && \
    rm -rf /tmp/facets && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

RUN jupyter nbclassic-extension install --py callystonb --sys-prefix && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY --chown=${NB_USER}:${NB_GID} Rprofile.site /opt/conda/lib/R/etc/Rprofile.site

RUN Rscript -e "install.packages('repurrsive', dependencies=TRUE)" && \
  Rscript -e "install.packages('canlang', dependencies=TRUE)"

WORKDIR "${HOME}"
