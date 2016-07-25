#!/bin/bash
set -e

testAlias+=(
	[bitcoind:trusty]='bitcoind'
)

imageTests+=(
	[bitcoind]='
		rpcpassword
	'
)
