FROM ubuntu:22.04

ENV TERM=xterm

RUN apt-get -qy update && \
  apt-get -y install build-essential autoconf libtool libncurses-dev yasm curl libcurl4-openssl-dev \
  libudev-dev libusb-1.0-0-dev pkg-config wget unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /cgminer
RUN wget https://github.com/vthoang/cgminer/archive/master.zip -O cgminer-vthoang.zip && \
  unzip cgminer-vthoang.zip && rm cgminer-vthoang.zip && \
  mv cgminer-master cgminer-vthoang

WORKDIR /cgminer/cgminer-vthoang

RUN ./autogen.sh && \
  export LIBCURL_CFLAGS='-I/usr/include/curl' && \
  export LIBCURL_LIBS='-L/usr/lib -lcurl' && \
  CFLAGS="-O2 -Wall" ./configure --enable-gekko && \
  make

RUN mv cgminer /usr/local/bin/cgminer
