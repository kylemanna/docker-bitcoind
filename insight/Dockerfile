FROM ubuntu:14.04
MAINTAINER Kobi Gurkan <kobigurk@gmail.com>

RUN apt-get update && apt-get install -y curl git python build-essential

RUN curl -sL https://deb.nodesource.com/setup | sudo bash -

RUN apt-get install -y nodejs

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /bitcoin
RUN useradd -s /bin/bash -m -d /bitcoin bitcoin
RUN mkdir /insight
RUN chown bitcoin:bitcoin -R /insight
RUN mkdir /insight_app
RUN chown bitcoin:bitcoin -R /insight_app

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER bitcoin

VOLUME ["/bitcoin", "/insight"]

EXPOSE 3000

WORKDIR /insight_app

RUN git clone https://github.com/bitpay/insight.git && cd insight && npm install
WORKDIR /insight_app/insight

COPY ./start.sh /insight_app/insight/start.sh

ENTRYPOINT ["/bin/bash"]
CMD ["start.sh"]
