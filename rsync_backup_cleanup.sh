#!/bin/bash

# Purpose: This script will remove backups that are older than 30 days that were created by the "rsync_backup.sh" script.
#  Author: Edward Hunt
#    Date: February 15, 2020
#  To Use: Make this script executable (chmod +x), and call it from crontab as "cleanup_folder $Destination".

cleanup_folder () {
        echo "CHECKING FOR BACKUPS OLDER THAN 30 DAYS..."
        cd ${Destination}
        pwd
        contents_of_backup_folder=`ls | grep -v ${date} | wc -l`
        if [ $contents_of_backup_folder -ne 0 ]; then
                for old_object in `ls | grep -v ${date}`
                do
                        echo "REMOVING OLD FOLDER: $old_object"
                        rm -rfv $old_object
                done
        else
                echo "NO CLEANUP NEEDED."
        fi
        cd -
}
