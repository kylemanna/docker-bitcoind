FROM ubuntu:14.04
MAINTAINER Levin Keller <github@levinkeller.de>

RUN apt-get update && \
    apt-get install git build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev -y

RUN git clone https://github.com/bitcoin/bitcoin.git && \\
    cd bitcoin
    git checkout v0.11.0
    ./autogen.sh
    ./configure --disable-wallet --without-gui
    make
    make install

EXPOSE 8333

CMD ["start.sh"]

