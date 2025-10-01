#!/bin/bash


mcrcon 'say [§4WARNING§r] Server backup process will begin in 5 minutes.'
sleep 5m

mcrcon 'say [§4WARNING§r] Server backup process is starting NOW.'

mcrcon "save-off"
mcrcon "save-all"
tar -cvpzf /opt/minecraft/backups/minecraft-$(date +%F_%R).tar.gz /opt/minecraft/run/minecraft
mcrcon "save-on"

mcrcon 'say [§bNOTICE§r] Server backup process is complete. Feel free to crash the server.'

## Delete older backups
find /opt/minecraft/backups/ -type f -mtime +7 -name 'minecraft-*.tar.gz' -delete
