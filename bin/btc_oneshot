#!/bin/bash

chown 1000:1000 /bitcoin
btc_init # generate bitcoin.conf
if [ ! -d /bitcoin/.bitcoin/blocks ]; then
  btc_bootstrap
fi

bitcoind -rpcallowip=*
