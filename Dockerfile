FROM ubuntu:14.04
MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y bitcoind

ENV HOME /bitcoin
RUN useradd --create-home --home-dir /bitcoin bitcoin
ADD bitcoind.sh /bitcoin/
RUN chown -R bitcoin:bitcoin /bitcoin
RUN chmod a+x /bitcoin/bitcoind.sh

VOLUME ["/bitcoin"]

EXPOSE 8332 8333

# FIXME: Get a strange permission denied error with bash, not sure why yet
#USER bitcoin

ENTRYPOINT ["/bitcoin/bitcoind.sh"]

# Default arguments, can be overriden
CMD ["-disablewallet"]
