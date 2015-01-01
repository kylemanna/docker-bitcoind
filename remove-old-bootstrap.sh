#!/bin/bash

if [ -e "$HOME/.bitcoin/bootstrap.dat.old" ]; then
  rm -f "$HOME/.bitcoin/bootstrap.dat.old"
  rm -f /etc/cron.d/remove-old-bootstrap
fi
