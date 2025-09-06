#!/usr/bin/env bash
. .env

mcrcon -H $IPV4 -p $PASSWORD stop
if [ "$?" -ne "0" ]; then
  echo "Failed to stop server! This must be a crash!"
  /opt/minecraft/run/sendmail/systemd-email.py
else
  echo "Stopped server!"
fi
