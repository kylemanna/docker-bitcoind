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
   
   while test $# -gt 0
   do
      if [ "$1" == "--bootstrap" ]; then
	aria2c --dir=$HOME http://gtf.org/garzik/bitcoin/bootstrap.txt
	gpg --ignore-time-conflict --keyserver pgp.mit.edu --recv-keys 7ADCA079
	gpg --verify $HOME/bootstrap.txt
	if [ $? -ne 0 ]; then
	  echo "Couldn't verify bootstrap torrent's signature"
	  exit 1
	fi
	
	link=$(cat $HOME/bootstrap.txt | grep --color=never "magnet:")
	rm $HOME/bootstrap.txt
	if [ -z "$link" ]; then
	  echo "Couldn't find the bootstrap magnet link"
	  exit 1
	fi
	
	aria2c --dir=$HOME/.bitcoin --listen-port=6881 --dht-listen-port=6882 --seed-time=0 $link
	
	exit $?
      fi
      shift
   done
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
      init "$@"
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
