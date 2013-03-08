#!/bin/bash

FTB_DIR=/opt/ftb
FTB_BACKUP_DIR=/home/minecraft/ftb-backups
FTB_RSYNC_DEST=/media/robertsegal/Minecraft

if ftb status > /dev/null; then
    snapshot_file="$FTB_BACKUP_DIR/hourly-snapshot.tar.gz"
    cd $FTB_DIR && tar cvzfp $snapshot_file .
    rsync -rlD --update $FTB_BACKUP_DIR $FTB_RSYNC_DEST
    echo "$(date): Created hourly snapshot at $snapshot_file\n"
else
    echo "$(date): FTB server is not running. Skipping hourly snapshot.\n"
fi