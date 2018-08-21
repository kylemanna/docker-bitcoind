#!/bin/bash
set -e

testAlias+=(
	[btcd:trusty]='btcd'
)

imageTests+=(
	[btcd]='
		rpcpass
	'
)
