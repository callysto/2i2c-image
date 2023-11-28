ARG BASE_CONTAINER=pimsubc/pims-syzygy:latest
FROM $BASE_CONTAINER
LABEL maintainer="Ian Allison <iana@pims.math.ca>"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    libflint-dev \
    libsundials-cvode4 \
    libsundials-cvodes4 \
    libsundials-ida4 \
    libsundials-idas3 \
    libsundials-kinsol4 \
    libsundials-nvecserial4 \
    libnlopt0 \
    libnlopt-dev \
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

# Ipopt
RUN git clone https://github.com/coin-or/coinbrew /var/coin-or
WORKDIR /var/coin-or
RUN chmod +x coinbrew

RUN chmod +x coinbrew \
  && ./coinbrew fetch Ipopt@3.14.12 Cbc@stable/2.10 --no-prompt \
  && ./coinbrew build Ipopt Cbc --prefix=/usr/local --no-prompt \
  && ./coinbrew install Ipopt Cbc --no-prompt \
  && rm -rf /var/coin-or

# Stan
ENV CMDSTAN_HOME=/usr/share/stan
RUN mkdir -p /opt/cmdstan \
  && curl -s -L https://github.com/stan-dev/cmdstan/releases/download/v2.33.1/cmdstan-2.33.1.tar.gz | \
     tar -C /opt/cmdstan -x -z --strip-components=1 -f - \
  && (cd /opt/cmdstan && echo "CC=g++" >> make/local && echo "CXX=g++" >> make/local && make build) \
  && mv /opt/cmdstan/stan /usr/share/stan \
  && echo "export CMDSTAN_HOME=${CMDSTAN_HOME}" > /etc/profile.d/cmdstan.sh \
  && chmod 755 /etc/profile.d/cmdstan.sh \
  && rm -rf /opt/cmdstan

ARG julia_version="1.6.7"
ARG julia_checksum="6c4522d595e4cbcd00157ac458a72f8aec01757053d2073f99daa39e442b2a36"

# Julia
ENV JULIA_VERSION="${julia_version}"
ENV JULIA_DIR="/opt/julia-${JULIA_VERSION}"
ENV JULIA_PKGDIR="/opt/julia-${JULIA_VERSION}/local/share/julia"

RUN mkdir -p "/opt/julia-${JULIA_VERSION}" \
  && wget -q https://julialang-s3.julialang.org/bin/linux/x64/$(echo "${JULIA_VERSION}" | cut -d. -f 1,2)"/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" \
  && echo "${julia_checksum} *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - \
  && tar xzf "julia-${JULIA_VERSION}-linux-x86_64.tar.gz" -C "${JULIA_DIR}" --strip-components=1 \
  && rm -f "${JULIA_DIR}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" \
  && ln -fs "${JULIA_DIR}/bin/julia" /usr/local/bin/julia \
  && chown -R "${NB_USER}" "${JULIA_DIR}" \
  && fix-permissions "${JULIA_DIR}"

USER jovyan
COPY --chown=${NB_UID}:${NB_GID} package-installs.jl /tmp/package-installs.jl
ENV NB_USER="jovyan" \
    HOME="/home/jovyan"

RUN julia /tmp/package-installs.jl \
 && mv ${HOME}/.local/share/jupyter/kernels/julia* ${CONDA_DIR}/share/jupyter/kernels/ \
 && rm -rf "${HOME}/.local" \
 && echo "push!(LOAD_PATH, \"${JULIA_PKGDIR}/environments/v$(echo ${JULIA_VERSION} | cut -d'.' -f -2)\")" >> ${JULIA_DIR}/etc/julia/startup.jl \
 && echo "using Pkg; Pkg.activate(\"/home/jupyter/.julia/environments/v$(echo {JULIA_VERSION} | cut -d'.' -f -2)\")" >> ${JULIA_DIR}/etc/julia/startup.jl

USER jupyter
ENV NB_USER=jupyter \
    NB_UID=9999
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/ \
    HOME=/home/$NB_USER

WORKDIR "${HOME}"
