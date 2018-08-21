#!/bin/bash
set -e

# Generate the password the first time
btc_init 2>/dev/null
eval `grep rpcpass $HOME/.btcd/btcd.conf`
rpcpass1=$rpcpass

# Generate the password again
rm ~/.btcd/btcd.conf
btc_init 2>/dev/null
eval `grep rpcpass $HOME/.btcd/btcd.conf`
rpcpass2=$rpcpass


# Check that password looks like a auto-generated base64 random value or better
if [ ${#rpcpass} -lt 16 ]; then
    echo "FAIL: RPC Password does not appear long enough" >&2
    exit 1
fi

# Check that each password was at least different
if [ "$rpcpass1" = "$rpcpass2" ]; then
    echo "FAIL: RPC Password does not appear to be random" >&2
    exit 2
fi
