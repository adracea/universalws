FROM ubuntu:latest

LABEL version="0.1.0"
LABEL repository="https://github.com/adracea/universalws"
LABEL maintainer="Alex Dracea <adracea@gmail.com>"

ENV LANGUAGE	      en_US.UTF-8
ENV LANG    	      en_US.UTF-8
ENV LC_ALL  	      en_US.UTF-8

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
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common
RUN add-apt-repository universe
ARG MVN_VERSION=3.8.5

ARG PYTHON_VERSION=3.10

RUN apt-get update
ENV JAVA_INSTALL_VERSION openjdk-16-jdk
ENV JAVA_HOME       /usr/lib/jvm/java-16-openjdk-amd64
ENV PATH 	    	    $JAVA_HOME/bin:$PATH
### Install Java openjdk 8
RUN apt-get -y install ${JAVA_INSTALL_VERSION} python${PYTHON_VERSION} build-essential

RUN wget https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz && tar -xf node-$NODE_VERSION-linux-x64.tar.xz && cd node-$NODE_VERSION-linux-x64/bin && export PATH=$PATH:$(pwd) && cd
RUN wget https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz && tar -xf apache-maven-${MVN_VERSION}-bin.tar.gz && ls && cd apache-maven-${MVN_VERSION}/bin && export PATH=$PATH:$(pwd) && cd

RUN apt install -y python3-pip python3-venv

RUN pip install pipenv
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH apache-maven-$MVN_VERSION/bin:node-$NODE_VERSION-linux-x64/bin:$JAVA_HOME/bin:$PATH
RUN npm i -g yarn
RUN npm i -g bower
# #clean up apt 
# RUN apt-get clean && \
# 	rm -rf /var/lib/apt/lists/* && \
# 	rm -rf /tmp/*


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x ./entrypoint.sh
ENTRYPOINT [ "/bin/sh","./entrypoint.sh" ]