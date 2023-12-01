ARG BASE_CONTAINER=jupyter/minimal-notebook:latest
FROM $BASE_CONTAINER
LABEL maintainer="Ian Allison <iana@pims.math.ca>"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  bison \
  build-essential \
  clang \
  cmake \
  curl \
  dbus \
  dvipng \
  epstool \
  fig2dev \
  flex \
  fonts-noto-cjk \
  fonts-noto-color-emoji \
  fonts-noto-mono \
  g++ \
  gcc \
  gfortran \
  git \
  gnuplot \
  gnuplot-x11 \
  gperf \
  gzip \
  icoutils \
  info \
  less \
  libarpack2-dev \
  libbison-dev \
  libcurl4-gnutls-dev \
  libfftw3-dev \
  libfltk1.3-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libgl1-mesa-dev \
  libgl2ps-dev \
  libglpk-dev \
  libgmp-dev \
  libgnutls28-dev \
  libgpgme-dev \
  libgraphicsmagick++1-dev \
  libhdf5-dev \
  liblapack-dev \
  libmpfr-dev \
  libopenblas-dev \
  libosmesa6-dev \
  libpcre3-dev \
  libqhull-dev \
  libqrupdate-dev \
  libqscintilla2-qt5-dev \
  libqt5opengl5-dev \
  libreadline-dev \
  librsvg2-bin \
  libseccomp-dev \
  libsndfile1-dev \
  libssl-dev \
  libsuitesparse-dev \
  libsundials-dev \
  libtool \
  libxft-dev \
  locales \
  lpr \
  lzip \
  make \
  mercurial \
  nettle-dev \
  openjdk-11-jdk \
  openjdk-8-jdk \
  openssh-client \
  perl \
  pkg-config \
  portaudio19-dev \
  pstoedit \
  python3-pip \
  qtbase5-dev \
  qttools5-dev \
  qttools5-dev-tools \
  rapidjson-dev \
  rsync \
  ssh-askpass \
  sudo \
  tar \
  texinfo \
  texlive-latex-extra \
  unzip \
  wget \
  xvfb \
  zip \
  zlib1g-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/conda/share/jupyter/lab/settings && \
  chown ${NB_USER}:${NB_GID} /opt/conda/share/jupyter/lab
COPY --chown=${NB_USER}:${NB_GID} jupyterlab-overrides.json \
  /opt/conda/share/jupyter/lab/settings/overrides.json

COPY --chown=${NB_USER}:${NB_GID} conda-linux-64.lock /tmp/conda-linux-64.lock
RUN mamba update --quiet --file /tmp/conda-linux-64.lock && \
    mamba clean --all -y -f && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# octave will have problems running if you don't run it via conda.
# init conda before installing packages and force it form notebooks
# in in kernel.json
COPY --chown=${NB_USER}:${NB_GID} octave-packages.m /tmp/octave-packages.m
RUN eval "$(command conda shell.bash hook 2> /dev/null)" && OCTAVE_HOME=/opt/conda octave /tmp/octave-packages.m
COPY --chown=${NB_USER}:${NB_GID} octave-kernel.json /opt/conda/share/jupyter/kernels/octave/kernel.json

COPY --chown=${NB_USER}:${NB_GID} pip.conf /etc/pip.conf
COPY --chown=${NB_USER}:${NB_GID} requirements.txt /tmp/requirements.txt
RUN echo "Installing python packages using pip from requirements.txt..." \
    && ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /tmp

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY --chown=${NB_USER}:${NB_GID} Rprofile.site /opt/conda/lib/R/etc/Rprofile.site

RUN Rscript -e "install.packages('repurrsive', dependencies=TRUE)" && \
  Rscript -e "install.packages('canlang', dependencies=TRUE)"

USER root

ENV SHELL /bin/bash
RUN useradd -m -s /bin/bash -N -u 9999 jupyter

USER jupyter
ENV NB_USER=jupyter \
    NB_UID=9999
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/ \
    HOME=/home/$NB_USER

HEALTHCHECK NONE

WORKDIR "${HOME}"
