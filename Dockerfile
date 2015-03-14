FROM ubuntu:14.04
MAINTAINER Kobi Gurkan <kobigurk@gmail.com>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e && \
    echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu trusty main" > /etc/apt/sources.list.d/bitcoin.list


RUN apt-get update && \
    apt-get install -y bitcoind aria2 git curl python build-essential

RUN curl -sL https://deb.nodesource.com/setup | sudo bash -

RUN apt-get install -y nodejs 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /bitcoin
RUN useradd -s /bin/bash -m -d /bitcoin bitcoin
RUN chown bitcoin:bitcoin -R /bitcoin
RUN mkdir /insight
RUN chown bitcoin:bitcoin -R /insight

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER bitcoin

VOLUME ["/bitcoin", "/insight"]

EXPOSE 8332 8333 6881 6882 3000

WORKDIR /bitcoin

CMD ["btc_oneshot"]
