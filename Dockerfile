ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/scipy-notebook:latest
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

RUN mamba install --quiet --yes \
    'altair' \
    'astropy' \
    'black' \
    'boto3' \
    'beautifulsoup4' \
    'biopython' \
    'cartopy' \
    'colorlover' \
    'cvxopt' \
    'flake8' \
    'folium' \
    'fuzzywuzzy' \
    'geos' \
    'geopandas' \
    'geopy' \
    'gfortran_linux-64' \
    'gmp' \
    'geopandas' \
    'googletrans' \
    'html5lib' \
    'imageio' \
    'ipysheet' \
    'ipycanvas' \
    'ipywidgets' \
    'lapack' \
    'markdown' \
    'mpfr' \
    'mpld3' \
    'nbconvert' \
    'nbval' \
    'nltk' \
    'nodejs' \
    'openpyxl' \
    'pandas' \
    'plotly' \
    'proj' \
    'psutil' \
    'pyqt' \
    'pysal' \
    'pyspellchecker' \
    'pytest' \
    'pytrends' \
    'qgrid' \
    'rdflib' \
    'rise' \
    'spacy' \
    'spacy-model-en_core_web_sm' \
    'spacy-model-en_core_web_md' \
    'spacy-model-en_core_web_lg' \
    'stats_can' \
    'tensorflow' \
    'textblob' \
    'textstat' \
    'tqdm' \
    'vega' \
    'vega_datasets' \
    'unidecode' \
    'wikipedia' \
    'wordcloud' \
    'lxml' && \ 
    mamba clean --all -y -f && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR /tmp
RUN jupyter nbextension install --py callystonb --sys-prefix && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY pip.conf /etc/pip.conf
COPY requirements.txt /tmp/requirements.txt
RUN echo "Installing python packages using pip from requirements.txt..." \
    && ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_UID}

WORKDIR "${HOME}"

ENV SHELL /bin/bash

USER ${NB_UID}
