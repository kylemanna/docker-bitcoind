FROM ubuntu:14.04
MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y bitcoind

ENV HOME /bitcoin
RUN useradd --create-home --home-dir $HOME bitcoin

ADD bitcoind.sh /usr/bin/
RUN chmod a+x /usr/bin/bitcoind.sh

VOLUME ["/bitcoin"]

EXPOSE 8332 8333

USER bitcoin

ENTRYPOINT ["bitcoind.sh"]

# Default arguments, can be overriden
CMD ["-disablewallet"]
