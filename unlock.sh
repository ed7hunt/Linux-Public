#! /bin/bash

# To make this script executable use:
# "chmod 500 /home/oracle/unlock.sh"

# To make this part of your shell, add the following line to root's .bashrc:
# "source /home/oracle/unlock.sh"

# To execute and learn how this script can be used:
# "unlock"
# "unlock [TAB]" to get a list of active enabled users containing 'DOR' in /etc/passwd

Green='\033[1;32m'
Yellow='\033[1;33m'
Red='\033[1;31m'
NC='\033[0m'
from="`who am i | awk '{ print $1 }'`"
complete -W "`grep ^z /etc/passwd | grep -i "DOR" | sed "s|:| |g" | egrep -iv "false|disabled" | awk '{ print $1 }'`" unlock

unlock () {
	username=$1
	log="/home/${username}/unlock_output.txt"
	if [ -z $username ] || [ $USER != "root" ]; then
		clear
		printf "     ${Green}Usage: unlock ${Yellow}[account]${Green}\n"
		printf "            unlock ${Yellow}[TAB]${Green} (will auto-complete selection) \n"
		if [ $USER != "root" ]; then
			printf "\nDependency: ${Red}You must be ${Yellow}\"root\"${Red} in order to run this script."
			printf "\n            Currently, you are logged in as ${Yellow}\"${from}\"${Red}."
			printf "\n  Solution: \"sudo ./root.sh\"\n"
		fi
		printf "\n     ${Green}Title: unlock.sh"
		printf "\n  Location: /home/oracle/unlock.sh"
		printf "\n   Purpose: Restores access to account owner without changing their password"
		printf "\n    Author: Edward H. Hunt IV"
		printf "\n   Version: 1.0"
		printf "\n      Date: 9/14/2018\n\n"
	else
		touch ${log}
		current_date="`date +%Y-%m-%d`"
		printf "Unlock command issued by ${from}@$USER on ${current_date}\n"

		# pam_tally can reside in 4 different locations depending on OS types.
		# These commands reset the PAM count for bad sudo commands and shows 
		# how many the account had. Usually 3 or more (per defined PAM security
		# settings) causes account to be locked out
		if [ -e /sbin/pam_tally ]; then
			/sbin/pam_tally --user ${username} --reset
		fi 
		if [ -e /sbin/pam_tally2 ]; then
			/sbin/pam_tally2 --user ${username} --reset
		fi
		if [ -e /bin/pam_tally ]; then
			/bin/pam_tally --user ${username} --reset
		fi
		if [ -e /bin/pam_tally2 ]; then 
			/bin/pam_tally2 --user ${username} --reset
		fi

		# The following command forces the account to become unlocked
		passwd -uf ${username}

		# The following command tricks the OS security into thinking the account owner changed their password
		# by simply modifying the date in /etc/shadow file to show the current date (in EPOCH format) 
		chage -d ${current_date} ${username}
		
		#I don't know if we need to use this or not, so I'm just putting this here for later reference.
		chage -I -1 ${username}

		# The following command lists the password aging information for account owner
		chage -l ${username}
		
		echo -e "\nA logfile was placed in ${username}'s home folder:\n${log}\n" 2>&1
		chown ${username} ${log}
		printf "${NC}"
	fi | tee -a ${log}	
}
