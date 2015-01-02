#!/bin/bash
#
# Configure broken host machine to run correctly
#
set -ex

distro=$1
shift

memtotal=$(grep ^MemTotal /proc/meminfo | awk '{print int($2/1024) }')

#
# Only do swap hack if needed
#
if [ $memtotal -lt 1024 -a $(swapon -s | wc -l) -lt 2 ]; then
   fallocate -l 512M /swap
   mkswap /swap
   echo "/swap swap swap defaults 0 0" >> /etc/fstab
   swapon -a
fi

free -m

if [ "$distro" = "trusty" -o "$distro" = "ubuntu:14.04" ]; then
    curl https://get.docker.io/gpg | apt-key add -
    echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
    apt-get update && apt-get install -y lxc-docker
fi

# Always clean-up, but fail successfully
docker kill bitcoind-data bitcoind-node || true
docker rm bitcoind-data bitcoind-node || true

# Always pull to avoid caching issues
docker pull kylemanna/bitcoind

docker run --name=bitcoind-data kylemanna/bitcoind init
docker run --volumes-from=bitcoind-data --name=bitcoind-node -d -p 8333:8333 -p 127.0.0.1:8332:8332 kylemanna/bitcoind bitcoind -disablewallet -rpcallowip=*

echo "JSON RPC credentials:"
# Sleep to allow the node to generate the credentials and avoid the race...
sleep 1
docker run --volumes-from=bitcoind-data --rm -it kylemanna/bitcoind cat /bitcoin/.bitcoin/bitcoin.conf
