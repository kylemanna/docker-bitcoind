#!/usr/bin/env bash
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
git checkout v0.11.0
./autogen.sh
./configure --disable-wallet --without-gui
NUM_CORES="$(grep -c ^processor /proc/cpuinfo)"
make -j $NUM_CORES
make install