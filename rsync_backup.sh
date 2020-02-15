#!/bin/bash

#      Filename: /root/rsync_backup.sh
#    Created by: Edward Hunt
# Last modified: June 25, 2019
# Executed from: crontab (via user=root)
#    Dependency: The following NFS share must be mounted in /etc/fstab:
# dor-is-exagrid1.dor-is.local:/home1/shares/vdbtdororaoem01_rsync to ${Destination} below:

Destination="/mnt/vdbtdororaoem01_rsync"
recipient_email="your.email@somewhere.com"
date=$(date +%Y_%B | tr "A-Z" "a-z" )
STARTTIME=$(date +%s)

get_configuration_info () {
	echo -e "\nSaving mount point and disk space info>"
	df -kh | tee ${Destination}/${date}/df_kh_`uname -n`
	echo -e "\nSaving top level directory level>"
	ls -al / | tee ${Destination}/${date}/ls_al_`uname -n`
	echo -e "\nSaving static routes>"
	netstat -rnv | tee ${Destination}/${date}/netstat_rnv_`uname -n`
}

decompress_folder () {
	echo "DECOMPRESSING ${Destination}/${date}.tar.gz ..."
	cd ${Destination}
	if [ -e ${Destination}/${date}.tar.gz ]; then	 
        	tar -zxf ${Destination}/${date}.tar.gz 
		echo "${Destination}/${date}.tar.gz EXISTS. DECOMPRESSION SUCCESSFUL."
		rm -rfv ${date}.tar.gz
	else 
		echo "${Destination}/${date}.tar.gz DOES NOT EXIST. DECOMPRESSION ABORTED."
	fi
	cd -
}

compress_folder () {
	echo "COMPRESSING ${Destination} into ${Destination}/${date}.tar.gz ..."
	cd ${Destination}
	tar -zcf ${date}.tar.gz ${date}/
	rm -rf ${date}/
	cd -
}

cleanup_folder () {
	echo "CHECKING FOR OLDER BACKUPS THAT WERE NOT MADE THIS MONTH..."
	cd ${Destination}
	pwd
	contents_of_backup_folder=`ls | grep -v ${date} | wc -l`
	if [ $contents_of_backup_folder -ne 0 ]; then
		for old_object in `ls | grep -v ${date}` 
		do
			echo "REMOVING OLD FOLDER: $old_object"
			rm -rf $old_object
		done
	else
		echo "NO CLEANUP NEEDED."
	fi
	cd -
}

if [[ -e ${Destination}/${date}.tar.gz && "`mount | grep -c $Destination`" = "1" ]]; then
	echo -e "\n****** BEGIN INCREMENTAL BACKUP ******"
	echo -e "\nLATEST FULL BACKUP = ${date}"
	echo "BACKUP DESTINATION = ${Destination}/${date}"
	echo "BACKUP START TIME = `date`" 	
	decompress_folder
	get_configuration_info
	echo -e "\nBackup user files and home directories>"
	rsync -av --delete --no-links /root ${Destination}/${date}/
	rsync -av --delete --no-links /home ${Destination}/${date}/
	echo -e "\nBackup logging folder>"
	rsync -axv --exclude='/var/spool/postfix/*' --no-specials --no-links --no-devices --delete /var  ${Destination}/${date}/
	echo -e "\nBackup configuration and operating system folders>"
	rsync -axv --delete --no-links /etc  ${Destination}/${date}/
	rsync -axv --delete --no-links /boot ${Destination}/${date}/
	# rsync -axv --no-specials --no-links --no-devices --delete /dev ${Destination}/${date}/
	rsync -axv --delete --no-links /usr  ${Destination}/${date}/
	rsync -axv --delete --no-links /opt  ${Destination}/${date}/
	rsync -axv --no-specials --no-devices --delete --no-links /run ${Destination}/${date}/
	compress_folder
	echo -e "\nINCREMENTAL BACKUP COMPLETED SUCCESSFULLY: `date`."
elif [[ -e ${Destination} && "`mount | grep -c $Destination`" = "1" ]]; then
	mkdir -pv ${Destination}/${date}/mnt/vdbtdororaoem01_rsync 
	mkdir -pv ${Destination}/${date}/mnt/vdbtdororaoem01_rman
	rsync -av --delete /mnt/README.txt ${Destination}/${date}/mnt/README.txt
	echo -e "\n****** BEGIN FULL BACKUP ******"
	mkdir -pv ${Destination}/${date}/mnt/vdbtdororaoem01_rsync 
	mkdir -pv ${Destination}/${date}/mnt/vdbtdororaoem01_rman
	rsync -av --delete /mnt/README.txt ${Destination}/${date}/mnt/README.txt
	echo "BACKUP DESTINATION = ${Destination}/${date}"
	echo "BACKUP START TIME = `date`" 	
	get_configuration_info
	echo -e "\nBackup user files and home directories>"
	rsync -av --delete --no-links /root ${Destination}/${date}/
	rsync -av --delete --no-links /home ${Destination}/${date}/
	echo -e "\nBackup logging folder>"
	rsync -axv --no-specials --no-devices --delete --no-links /var  ${Destination}/${date}/
	echo -e "\nBackup configuration and operating system folders>"
	rsync -av --delete --no-links /etc  ${Destination}/${date}/
	rsync -av --delete --no-links /boot ${Destination}/${date}/
	# rsync -axv --no-specials --no-devices --delete --no-links /dev  ${Destination}/${date}/
	rsync -av --delete --no-links /usr  ${Destination}/${date}/
	rsync -av --delete --no-links /opt  ${Destination}/${date}/
	rsync -axv --no-specials --no-devices --delete --no-links /run  ${Destination}/${date}/
	compress_folder
	cleanup_folder
	echo -e "\nFULL BACKUP COMPLETED SUCCESSFULLY: `date`."
else
        echo -e "\nBACKUP FAILED: `date`.\n\nPossible reasons:\n1) Mount point ${Destination} does not exist.\n2) NFS mount point turned off in /etc/fstab (run mount ${Destination} to fix)\n3) Target destination ${Destination} could be full.\n\n`df -kh`"
fi | tee -a ${Destination}/rsync_backup_${date}.log
ENDTIME=$(date +%s)
echo -e "\nIt took $((($ENDTIME - $STARTTIME)/60)) minutes to complete the backup." | tee -a ${Destination}/rsync_backup_${date}.log
echo -e "\n****** END OF BACKUP ACTIVITY ******" | tee -a ${Destination}/rsync_backup_${date}.log
