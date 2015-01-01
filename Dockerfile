FROM ubuntu:14.04
MAINTAINER Kyle Manna <kyle@kylemanna.com>


RUN useradd -s /bin/bash -m -d /bitcoin bitcoin
RUN chown bitcoin:bitcoin -R /bitcoin

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e
RUN echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu trusty main" > /etc/apt/sources.list.d/bitcoin.list
RUN apt-get update
RUN apt-get install -y bitcoind
RUN apt-get install -y aria2

ADD bitcoind.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/bitcoind.sh

ENV HOME /bitcoin

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER bitcoin

VOLUME ["/bitcoin"]

EXPOSE 8332 8333

ENTRYPOINT ["/usr/local/bin/bitcoind.sh"]

# Default arguments, can be overriden
CMD ["bitcoind", "-disablewallet"]
