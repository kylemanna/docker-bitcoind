#!/bin/bash

export BITCOIND_PASS=`echo $(cat /bitcoin/.bitcoin/bitcoin.conf | grep rpcpassword | awk '{split($0,a,"="); print a[2]}' | tr -d "\r" | tr -d "\n")`
INSIGHT_NETWORK=livenet INSIGHT_DB=/insight BITCOIND_HOST=bitcoind BITCOIND_PORT=8332 BITCOIND_USER=bitcoinrpc BITCOIND_PASS=$BITCOIND_PASS npm start
