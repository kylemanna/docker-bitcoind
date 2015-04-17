#!/bin/bash
#
# Configure broken host machine to run correctly
#
set -ex

BTC_IMAGE=${BTC_IMAGE:-kylemanna/bitcoind}
INSIGHT_IMAGE=${INSIGHT_IMAGE:-kobigurk/insight}

distro=$1
shift

memtotal=$(grep ^MemTotal /proc/meminfo | awk '{print int($2/1024) }')

#
# Only do swap hack if needed
#
if [ $memtotal -lt 2048 -a $(swapon -s | wc -l) -lt 2 ]; then
    fallocate -l 2048M /swap || dd if=/dev/zero of=/swap bs=1M count=2048
    mkswap /swap
    grep -q "^/swap" /etc/fstab || echo "/swap swap swap defaults 0 0" >> /etc/fstab
    swapon -a
fi

free -m

if [ "$distro" = "trusty" -o "$distro" = "ubuntu:14.04" ]; then
    curl https://get.docker.io/gpg | apt-key add -
    echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

    # Handle other parallel cloud init scripts that may lock the package database
    # TODO: Add timeout
    while ! apt-get update; do sleep 10; done

    while ! apt-get install -y lxc-docker; do sleep 10; done
fi

# Always clean-up, but fail successfully
docker kill bitcoind-data bitcoind-node 2>/dev/null || true
docker rm bitcoind-data bitcoind-node 2>/dev/null || true
stop docker-bitcoind 2>/dev/null || true

# Always pull remote images to avoid caching issues
if [ -z "${BTC_IMAGE##*/*}" ]; then
    docker pull $BTC_IMAGE
fi

if [ -z "${INSIGHT_IMAGE##*/*}" ]; then
    docker pull $INSIGHT_IMAGE
fi

# Initialize the data container
docker run --name=bitcoind-data -v /bitcoin busybox chown 1000:1000 /bitcoin
docker run --name=insight-data -v /insight busybox chown 1000:1000 /insight
docker run --volumes-from=bitcoind-data --rm $BTC_IMAGE btc_init


# Start bitcoind via upstart and docker
curl https://raw.githubusercontent.com/kobigurk/docker-bitcoind/master/upstart.init > /etc/init/docker-bitcoind.conf
start docker-bitcoind

set +ex
echo "Resulting bitcoin.conf:"
docker run --volumes-from=bitcoind-data --rm $BTC_IMAGE cat /bitcoin/.bitcoin/bitcoin.conf
