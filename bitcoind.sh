#!/bin/bash

cmd=$1
shift

init() {
   # This shouldn't be in the Dockerfile or containers built from the same image
   # will have the same credentials.
   if [ ! -e "$HOME/.bitcoin/bitcoin.conf" ]; then
      mkdir -p $HOME/.bitcoin
      bitcoind 2>&1 | grep "^rpc" > $HOME/.bitcoin/bitcoin.conf
   fi
}

case $cmd in
   shell)
      sh -c "$*"
      exit $?
      ;;
   login)
      bash -l
      exit $?
      ;;
   init)
      init
      exit 0
      ;;
   bitcoind)
      bitcoind "$@"
      exit $?
      ;;
   log)
      tail -f $HOME/.bitcoin/debug.log
      ;;
   getconfig)
      cat $HOME/.bitcoin/bitcoin.conf
      ;;
   *)
      echo "Unknown cmd $cmd"
      exit 1
esac
