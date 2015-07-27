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

COPY start.sh /scripts/start.sh

COPY buildAndInstallBitcoin.sh /scripts/buildAndInstallBitcoin.sh

RUN /scripts/buildAndInstallBitcoin.sh

ENV RPC_USER=user \
    RPC_PASSWORD=password \
    BITCOIN_PORT=8333 \
    RPC_PORT=8332

VOLUME /bitcoin

EXPOSE 8333 8332

ENTRYPOINT ["/scripts/start.sh"]

