FROM bioconductor/bioconductor_docker:RELEASE_3_12
MAINTAINER todd.creasy@astrazeneca.com
ARG PYTHON=python3
ARG PIP=pip3

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN  rm -f /var/lib/dpkg/available && rm -rf  /var/cache/apt/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    unzip \
    pkg-config \
    curl \
    ${PYTHON} \
    ${PYTHON}-pip && \
    apt-get clean

RUN ${PIP} install --upgrade pip
RUN ${PIP} install --upgrade setuptools

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN ${PIP} install numpy pandas matplotlib seaborn scikit-learn

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y  install --fix-missing tcl8.6-dev \
    tk \
    expat \
    libexpat-dev && \
    apt-get clean

RUN echo "R_LIBS=/usr/local/lib/R/host-site-library:\${R_LIBS}" > /usr/local/lib/R/etc/Renviron.site
RUN echo "R_LIBS_USER=''" >> /usr/local/lib/R/etc/Renviron.site
RUN echo "options(defaultPackages=c(getOption('defaultPackages'),'BiocManager'))" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages(c("missForest", "glmnet", "caret", "doParallel", "dbplyr", "randomforest", "docopt"))'
RUN R -e 'BiocManager::install("biomaRt")'

WORKDIR /opt/

# Install Nextflow
RUN curl -s https://get.nextflow.io | bash
RUN chmod +x nextflow
RUN mv nextflow /usr/local/bin

# Install COSMO
RUN git clone https://github.com/toddcreasy/cosmo

COPY ./run_cosmo.sh /opt
ENTRYPOINT ["/opt/run_cosmo.sh"]

#specify the command executed when the container is started
#CMD ["/bin/bash"]
CMD ["-u", "-m", "swagger_server"]