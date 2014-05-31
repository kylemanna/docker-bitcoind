FROM ubuntu:14.04
MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e
RUN echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu trusty main" > /etc/apt/sources.list.d/bitcoin.list
RUN apt-get update
RUN apt-get install -y bitcoind

ENV HOME /bitcoin
RUN useradd -s /bin/bash -m -d /bitcoin bitcoin

ADD bitcoind.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/bitcoind.sh

# FIXME: Get a strange permission denied error with bash, not sure why yet
USER bitcoin

VOLUME ["/bitcoin"]

EXPOSE 8332 8333

ENTRYPOINT ["/usr/local/bin/bitcoind.sh"]

# Default arguments, can be overriden
CMD ["run", "-disablewallet"]
