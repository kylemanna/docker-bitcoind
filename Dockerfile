FROM ubuntu:14.04
MAINTAINER Levin Keller <github@levinkeller.de>

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
 git \
 build-essential \
 libtool \
 autotools-dev \
 autoconf \
 pkg-config \
 libssl-dev \
 libboost-all-dev \
 bsdmainutils

RUN git clone https://github.com/bitcoin/bitcoin.git \
 && cd bitcoin \
 && git checkout v0.11.0 \
 && ./autogen.sh \
 && ./configure --disable-wallet --without-gui \
 && make \
 && make install

VOLUME /bitcoin/database

EXPOSE 8333

COPY start.sh /start.sh
CMD ["/start.sh"]

