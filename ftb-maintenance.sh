#!/bin/bash

FTB_MAX_BACKUPS=6
FTB_BACKUP_DIR=/home/minecraft/ftb-backups
FTB_RSYNC_DEST=/media/robertsegal/Minecraft

num_backups() {
    ls -b $FTB_BACKUP_DIR/*.tar.gz | wc -l
}

delete_oldest_backup() {
    ls -b $FTB_BACKUP_DIR/*.tar.gz | sort | head -1 | xargs rm
}

warning() {
    echo "Issuing server shutdown notice to connected players."
    ftb say "Server will shut down for routine maintenance in 10 seconds."
    ftb say "Downtime will be approximately 3 minutes."
    sleep 10
}

(ftb who > /dev/null) && warning

echo "Running FTB maintenance script on $(date)."
ftb stop
ftb backup
ftb start

# The following code works, but is obsolete with the rsync options below
#while [ "$(num_backups)" -gt "$FTB_MAX_BACKUPS" ]; do
#    delete_oldest_backup
#done

rsync -rlD --update $FTB_BACKUP_DIR $FTB_RSYNC_DEST
echo -e "FTB maintenance script completed on $(date).\n"
