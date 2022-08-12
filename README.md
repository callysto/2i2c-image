# An 2i2c Compatible Image for Callysto

This repository provides the environment to be run for
[callysto](https://callysto.ca) via [2i2c](https://2i2c.org). Basically, it
defines a docker image based on
[docker-stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/) which
includes the packages and configurations needed to run the Callysto notebooks.
The default is to build from the `juptyer/minimal-notebook:latest` image, but if
you want more reproducible builds, that repository typically includes date tags
as well and you can override the base image with e.g.
```bash
$ make build-all DOCKER_BUILD_ARGS="--build-arg \
    BASE_CONTAINER=jupyter/minimal-notebook:2022-08-11"
```


## Quick Build Instructions

A Makefile is provided which will help build, tag and push images similar to
what is done in
[docker-stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/) (that's
where the Makefile originates). To build and tag the image, try
```bash
$ make build-all
```
As long as you have docker installed, that should build
`callysto/callysto-notebook:latest`.

You can also build the image manually from the [image
directory](./callysto-notebook), by running e.g.
```bash
$ docker build -t callysto-notebook:latest .
```


### Package Management
As far as possible, package management is handled by
[mamba](https://anaconda.org/conda-forge/mamba), which is a drop-in alternative
to conda but with more efficient dependency resolution. Packages dependencies
are listed in `environment.yml` which is processed by
[conda-lock](https://anaconda.org/conda-forge/conda-lock) to produce a lockfile
for reproducible builds. A handful of other packages and utilities are installed
by either `apt` or `pip`. The `environment.yml` file supports direct
versioning where appropriate (e.g. `python=3.8`, but as far as possible, we
prefer to follow the development of the underlying packages to keep the
image up to date and relevant.

Assuming you have conda/mamba installed somewhere, you can generate an updated
conda-lock.yml with
```bash
# Assuming miniconda is installed somewhere
$ conda install -c conda-forge conda-lock mamba
$ conda-lock --mamba -k explicit --file environment.yml -p linux-64
```

The Dockerfile will process that lock file and install those packages via mamba.
Note that the underlying image for the docker build is usually
`jupyter/minimal-notebook:latest`, but if you need something more reproducible
you can try overriding the `BASE_CONTAINER` argument. That said, there are some
apt-get update and apt-get install commands which might install slight different
packages as the ubuntu repositories are updated.
