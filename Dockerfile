ARG container_version=20.04
FROM ubuntu:${container_version}

LABEL author="Nicola Spallanzani - nicola.spallanzani@nano.cnr.it - S3 centre, CNR-NANO"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yqq update \
 && apt-get -yqq install --no-install-recommends \
        build-essential ca-certificates curl file \
        make gcc g++ gfortran \
        git gnupg2 iproute2 lmod locales lua-posix \
        python2 python3 python3-pip python3-setuptools \
        tcl unzip m4 wget git zlib1g-dev ssh \
 && apt-get clean \
 && locale-gen en_US.UTF-8 \
 && pip3 install boto3

ENV SPACK_ROOT=/opt/spack \
    PATH=/opt/spack/bin:$PATH

RUN cd /opt && git clone https://github.com/spack/spack.git && cd spack && git checkout releases/v0.16 && . share/spack/setup-env.sh \
 && spack install openmpi@4.0.2 %gcc@9.3.0 fabrics=psm2,verbs,ofi,mxm,hcoll +pmi \
 && spack install intel-mkl && spack clean --stage && spack clean -a && spack clean --downloads && spack clean --misc-cache
