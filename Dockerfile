FROM ubuntu-upstart:14.04
MAINTAINER bplotka <bartlomiej.plotka@intel.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Install Dependencies
RUN apt-get update -q --fix-missing && \
    apt-get -qy install \
    software-properties-common             \
    libxext-dev                            \
    libxrender-dev                         \
    libxrender1                            \
    libxslt1.1                             \
    libxtst-dev                            \
    libgtk2.0-0                            \
    libcanberra-gtk-module                 \
    unzip                                  \
    build-essential                        \
    autoconf                               \
    automake                               \
    git

RUN add-apt-repository ppa:webupd8team/java -y && \
    add-apt-repository ppa:george-edison55/cmake-3.x && \
    apt-cache policy cmake && \
    apt-get update -qq && \
    echo 'Installing JAVA 8' && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -qq -y --fix-missing    \
    oracle-java8-installer                  \
    cmake=3.2.2-2ubuntu2~ubuntu14.04.1~ppa1 \
    ca-certificates                         \
    gdb                                     \
    wget                                    \
    git-core                                \
    libcurl4-nss-dev                        \
    libsasl2-dev                            \
    libtool                                 \
    libsvn-dev                              \
    libapr1-dev                             \
    libgoogle-glog-dev                      \
    libboost-dev                            \
    protobuf-compiler                       \
    libprotobuf-dev                         \
    make                                    \
    python                                  \
    python2.7                               \
    libpython-dev                           \
    python-dev                              \
    python-protobuf                         \
    python-setuptools                       \
    heimdal-clients                         \
    libsasl2-modules-gssapi-heimdal         \
    clang-3.5                               \
    vim                                     \
    --no-install-recommends

RUN echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Download clion.
RUN wget -P /tmp/ http://download.jetbrains.com/cpp/clion-1.2.2.tar.gz

# Unpack clion.
RUN mkdir -p /opt/clion && \
    tar zxvf /tmp/clion-1.2.2.tar.gz --strip-components=1 -C /opt/clion && \
    rm /tmp/clion-1.2.2.tar.gz

# Install the picojson headers
RUN wget https://raw.githubusercontent.com/kazuho/picojson/v1.3.0/picojson.h -O /usr/local/include/picojson.h

# Prepare to build Mesos
RUN mkdir -p /mesos
RUN mkdir -p /tmp
RUN mkdir -p /usr/share/java/
RUN wget http://search.maven.org/remotecontent?filepath=com/google/protobuf/protobuf-java/2.5.0/protobuf-java-2.5.0.jar -O protobuf.jar
RUN mv protobuf.jar /usr/share/java/

USER root
ENV CL_JDK=/usr/lib/jvm/oracle-jdk-8
ENV HOME=/root

WORKDIR /root

# Pass your own clion configuration.
VOLUME ["/root/.CLion12"]
VOLUME ["/mesos"]

CMD ["/opt/clion/bin/clion.sh", "/mesos"]