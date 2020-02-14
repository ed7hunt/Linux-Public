#!/bin/bash

# convert_sudo_date.sh converts sudo logs with epoch dates to human readable form
# To make executable:
# chmod +x convert_sudo_date.sh
# Execute command:
# ./convert_sudo_date.sh
# Follow instructions.

sudo_log=$1
if [ -z $sudo_log ]; then
		clear
		echo 'usage: convert_sudo_date.sh [input.file]'
		echo -e "\npurpose: This script converts the epoch dates inside of \"input.file's\" sudo logs to human readable form."
		echo -e "\ncreated by: Ed Hunt, July 20, 2017\n\n"
else
	while read x
	do
		if [ `echo $x | egrep -c "^#"` = 1 ]; then
			date -d `echo $x | tr "#" "@"` +"%b %d, %Y %H:%M:%S"
		else
			echo $x
		fi
	done < $sudo_log > temp
	cat temp | tee $sudo_log
	rm temp
fi
