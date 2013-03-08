#!/bin/bash

FTB_MAX_BACKUPS=14
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

if ftb status > /dev/null; then
    if ftb who > /dev/null; then
	warning
    fi

    echo "Running FTB maintenance script on $(date)."
    ftb stop
    ftb backup
    ftb start

    echo "Copying backup to NAS."
    rsync -rlD --update $FTB_BACKUP_DIR $FTB_RSYNC_DEST

    # The following code works, but is obsolete with the rsync options below
    #while [ "$(num_backups)" -gt "$FTB_MAX_BACKUPS" ]; do
    #    delete_oldest_backup
    #done

    echo -e "FTB maintenance script completed on $(date).\n"

else
    echo -e "$(date): FTB server is not running. Skipping scheduled maintenance.\n"
fi