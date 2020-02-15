# !/bin/bash

#      Filename: /root/symantec_scan.sh
#	Purpose: This prevents Symantec savtray from breaking the Gnome X-Windows display (which disables the console).
#    Created by: Edward Hunt
# Last modified: Feb 15, 2018
# Executed from: crontab (via user=root)
#    Dependency: Symantec Endpoint Protection must be installed.
#  Run schedule: Midnight every day.
#                It takes 105 minutes to run a Live Update and a full scan. 

include_directories="/boot /dev /etc /home /media /opt /proc /root /run /srv /sys /tmp /usr /var"
touch /var/log/symantec/scan.log
chmod 600 /var/log/symantec/scan.log
chown root:root /var/log/symantec/scan.log
STARTTIME=$(date +%s)

chkconfig --level 2345 autoprotect off
chkconfig --level 2345 sav off
chkconfig --level 2345 savtray off
chkconfig --level 2345 rtvscand off
chkconfig --level 2345 smcd off
chkconfig --level 2345 symcfgd off


echo -e "\n*********** BEGIN NORTON ANTIVIRUS SCAN ***********"

if [ -e /var/log/symantec/scan.log ]; then 
	echo -e "\nSTART TIME = `date`" 
	echo -e "\n# SYMANTEC PROCESSES RUNNING = `ps -ef | grep -v grep | egrep -c "sav|savtray|rtvscand|smcd|symcfgd"`"
	ps -ef | grep -v grep | egrep "sav|savtray|rtvscand|smcd|symcfgd" 
	echo -e "\nStarting Symantec processes >"
	if [ `/opt/Symantec/symantec_antivirus/smcd -k check | grep -c "is running"` == "1" ]; then
		/opt/Symantec/symantec_antivirus/smcd -k check
	else
		echo "Starting /opt/Symantec/symantec_antivirus/smcd | Checking . . ."
		/opt/Symantec/symantec_antivirus/smcd
		sleep 10
		/opt/Symantec/symantec_antivirus/smcd -k check
	fi 
        if [ `/opt/Symantec/symantec_antivirus/symcfgd -k check | grep -c "is running"` == "1" ]; then
                /opt/Symantec/symantec_antivirus/symcfgd -k check
        else
		echo "Starting /opt/Symantec/symantec_antivirus/symcfgd | Checking . . ."
                /opt/Symantec/symantec_antivirus/symcfgd
                sleep 10
		/opt/Symantec/symantec_antivirus/symcfgd -k check
        fi
        if [ `/opt/Symantec/symantec_antivirus/rtvscand -k check | grep -c "is running"` == "1" ]; then
                /opt/Symantec/symantec_antivirus/rtvscand -k check
        else
		echo "Starting /opt/Symantec/symantec_antivirus/rtvscand | Checking . . ."
                /opt/Symantec/symantec_antivirus/rtvscand
                sleep 10
                /opt/Symantec/symantec_antivirus/rtvscand -k check
        fi
        echo -e "\nInitiating Live Update >"
	/opt/Symantec/symantec_antivirus/sav liveupdate -u
	sleep 10
	processes=`ps -ef | grep -v grep | egrep -c "sav|savtray|rtvscand|smcd|symcfgd"`
	echo -e "\n# SYMANTEC PROCESSES RUNNING = ${processes}"
	ps -ef | grep -v grep | egrep "sav|savtray|rtvscand|smcd|symcfgd"
	if [ ${processes} == "3" ]; then
		echo -e "\nRunning full manual scan >\nDirectories = ${include_directories}"
		/opt/Symantec/symantec_antivirus/sav manualscan -c ${include_directories}
	else
		echo -e "\nScan was not possible without all 3 processes running."
	fi
	sleep 10
	#Symantec shutdown script
	echo -e "\nShutting Down Symantec Processes >"
	kill -9 `ps -ef | grep -v grep | grep savtray | awk '{ print $2 }'`
	echo "Stopping /opt/Symantec/symantec_antivirus/symcfgd | Checking . . ."
	/opt/Symantec/symantec_antivirus/symcfgd -k shutdown
	sleep 10 
	/opt/Symantec/symantec_antivirus/symcfgd -k check
	echo "Stopping /opt/Symantec/symantec_antivirus/smcd | Checking . . ."
	/opt/Symantec/symantec_antivirus/smcd -k shutdown
	sleep 10 
	/opt/Symantec/symantec_antivirus/smcd -k check
	echo "Stopping /opt/Symantec/symantec_antivirus/rtvscand | Checking . . ."
        /opt/Symantec/symantec_antivirus/rtvscand -k shutdown
        sleep 10
        /opt/Symantec/symantec_antivirus/rtvscand -k check
	echo -e "\n# SYMANTEC PROCESSES RUNNING = `ps -ef | grep -v grep | egrep -c "sav|savtray|rtvscand|smcd|symcfgd"`"
	ps -ef | grep -v grep | egrep "sav|savtray|rtvscand|smcd|symcfgd"
        echo -e "\nSTOP TIME = `date`"  
	ENDTIME=$(date +%s)
	echo "It took $((($ENDTIME - $STARTTIME)/60)) minutes to complete this task."
else 
	echo "COULD NOT CREATE /var/log/symantec/scan.log"
fi | tee -a /var/log/symantec/scan.log
echo -e "\n************ END NORTON ANTIVIRUS SCAN ************" | tee -a /var/log/symantec/scan.log
