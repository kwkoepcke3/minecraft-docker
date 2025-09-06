#!/bin/bash

function rcon {
  mcrcon -p W5i6PBoXz4Kk "$1"
}

rcon 'say [§4WARNING§r] Server backup process will begin in 5 minutes.'
sleep 5m

rcon 'say [§4WARNING§r] Server backup process is starting NOW.'

rcon "save-off"
rcon "save-all"
tar -cvpzf /opt/minecraft/backups/$SERVER_NAME/minecraft-$(date +%F_%R).tar.gz /opt/minecraft/run/minecraft
rcon "save-on"

rcon 'say [§bNOTICE§r] Server backup process is complete. Feel free to crash the server.'

## Delete older backups
find /opt/minecraft/backups/$SERVER_NAME -type f -mtime +7 -name 'minecraft-*.tar.gz' -delete
