#!/usr/bin/env bash
rm /bitcoin/bitcoin.conf
touch /bitcoin/bitcoin.conf
echo 'rpcuser=$RPC_USER' >> /bitcoin/bitcoin.conf
echo 'rpcpassword=$RPC_PASSWORD' >> /bitcoin/bitcoin.conf
cat /bitcoin/bitcoin.conf
bitcoind -datadir=/bitcoin