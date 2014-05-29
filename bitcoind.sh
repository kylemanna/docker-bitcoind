#!/bin/bash

# This shouldn't be in the Dockerfile or containers built from the same image
# will have the same credentials.
if [ ! -e "$HOME/.bitcoin/bitcoin.conf" ]; then
   mkdir -p $HOME/.bitcoin
   bitcoind 2>&1 | grep "^rpc" > $HOME/.bitcoin/bitcoin.conf
fi

bitcoind "$@"
