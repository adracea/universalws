FROM ubuntu:jammy

LABEL version="0.1.0"
LABEL repository="https://github.com/adracea/universalws"
LABEL maintainer="Alex Dracea <adracea@gmail.com>"

ENV LANGUAGE	      en_US.UTF-8
ENV LANG    	      en_US.UTF-8
ENV LC_ALL  	      en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
### Install wget, curl, git, unzip, gnupg, locales
RUN apt-get update && apt-get -y install \
      curl \
      git \
      gnupg \
      locales  \
      unzip \
      wget \
      jq \
    && locale-gen en_US.UTF-8

ARG NODE_VERSION=v16.14.2
ARG MVN_VERSION=3.8.6

ARG PYTHON_VERSION=3.6
ENV DISTRO 'jammy'
ENV JAVA_INSTALL_VERSION jdk-18
ENV JAVA_HOME       /opt/${JAVA_INSTALL_VERSION}
ENV PATH 	    	    $JAVA_HOME/bin:$PATH
### Install Java openjdk vers

# RUN echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu $DISTRO main" | tee /etc/apt/sources.list.d/ppa_openjdk-r.list && \
#     apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys DA1A4A13543B466853BAF164EB9B1D8886F44E2A
RUN wget https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_linux-x64_bin.tar.gz && \
        tar -xvf openjdk-18_linux-x64_bin.tar.gz && \
        mv jdk-18* /opt/
RUN apt-get update
# RUN snap install openjdk
RUN apt-get -y install python${PYTHON_VERSION} build-essential

RUN wget https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz && tar -xf node-$NODE_VERSION-linux-x64.tar.xz && cd node-$NODE_VERSION-linux-x64/bin && export PATH=$PATH:$(pwd) && cd
RUN wget https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz && tar -xf apache-maven-${MVN_VERSION}-bin.tar.gz && ls && cd apache-maven-${MVN_VERSION}/bin && export PATH=$PATH:$(pwd) && cd

RUN apt install -y python3-pip python3-venv

RUN pip install pipenv
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH apache-maven-$MVN_VERSION/bin:node-$NODE_VERSION-linux-x64/bin:$JAVA_HOME/bin:$PATH
RUN npm i -g yarn
RUN npm i -g bower
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x ./entrypoint.sh
RUN alias python=python3
ENTRYPOINT [ "/entrypoint.sh" ]
