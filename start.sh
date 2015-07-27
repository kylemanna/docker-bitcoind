#!/usr/bin/env bash
rm /bitcoin.conf
touch /bitcoin.conf
echo 'rpcuser='$RPC_USER >> /bitcoin.conf
echo 'rpcpassword='$RPC_PASSWORD >> /bitcoin.conf
echo 'rpcpassword='$RPC_PASSWORD >> /bitcoin.conf
echo 'rpcport='$RPC_PORT >> /bitcoin.conf
cat /bitcoin.conf
bitcoind -datadir=/bitcoin -conf=/bitcoin.conf