#!/bin/bash

sort_this() {
	arg1=$1
	if [ -z $arg1 ]; then
		clear
		echo "usage: sort_this [list]"
		echo -e "\nLOCATION: .bashrc"
		echo -e "\nDISTRIBUTED BY: Eds_password_script_$version"
		echo -e "\nPURPOSE: Sorts in alphabetical order your list. It also converts upper case to lower case and removes DOS carriage returns that inhibit scripting. It is useful to sort hostnames provided by customers."
	else
		echo "Save your list and close before continuing"
		gedit $arg1
		read -p "Press [Enter] key when ready."
		for hostname in $(cat $arg1)
		do
		i=$(echo $hostname | tr '[:upper:]' '[:lower:]' | sed -e 's//\n/g')
		echo $i >> temp.list 
		done
		uniq temp.list | sort -n > $arg1
		rm -f temp.list 	
		gedit $arg1 &
	fi
}

gedit dor_hostnames.txt
sort_this dor_hostnames.txt

if [ -e output.txt ]; then 
	rm -f output.txt
fi
echo "SEP=," > output.csv
echo "Hostname","IP","FQDN","Domain" >> output.csv
#EXADATA DOMAINS: bkup.local clus.local mgmt.local
domainlist=(devsog.local sog.local devextsog.local extsog.local dor.ga.gov rev.dor.ga.gov dor.state.ga.us etax.dor.ga.gov garevenue.local mgmt.local bkup.local clus.local)
domainlist_array_length=${#domainlist[@]}
for hostname in $(cat dor_hostnames.txt)
do
	domain_not_found1=0
	domain_not_found2=0
	for count in `seq 0 $(($domainlist_array_length-1))`
	do
		ipaddress=""
		FQDN=""
		domain=${domainlist[$count]}
		ipaddress="`nslookup $hostname.$domain | tail -n 2 | head -n 1 | tr '[:upper:]' '[:lower:]' | grep "address: " | sed "s/address: //g"`"

		FQDN="`nslookup $hostname | egrep "name = " | awk '{ print $4 }' | sed "s|\.$||g"`"
			hostname2="`echo $FQDN | tr "." " " | awk '{ print $1 }'`"
			ipaddress2=$hostname
			domain2="`echo $FQDN | tr "." " " | awk '{ print $2,$3,$4,$5,$6,$7,$8 }' | sed "s| |.|g" | sed "s|\.\.||g" | sed "s|\.$||g"`"
		


		if [ -n "$ipaddress" ]; then
			echo "$hostname,$ipaddress,$hostname.$domain,$domain"
			nslookup1="PASSED"
		else 
			domain_not_found1=$[domain_not_found1+1]
			nslookup1="FAILED"
		fi
		if [[ -n "$FQDN" && $domain_not_found1 -eq $domainlist_array_length ]]; then
			echo "$hostname2,$ipaddress2,$FQDN,$domain2"
			nslookup2="PASSED"
		else 
			domain_not_found2=$[domain_not_found2+1]
			nslookup2="FAILED"
		fi

		if [[ $domain_not_found1 -eq $domainlist_array_length && $domain_not_found2 -eq $domainlist_array_length && "$nslookup1" -eq "FAILED" && "$nslookup2" -eq "FAILED" ]]; then
			hostname3="`whois $hostname | egrep "NetName|Domain Name:" | awk '{ print $2 $3 }' | sed "s|Name:||g"`"
			if [ -n "$hostname3" ]; then
				FQDN2="`whois $hostname | grep -i "email:" | tail -n 1 | tr "@" " " | awk '{ print $3 }'`"
				domain3="`echo $FQDN2 | tr "." " " | awk '{ print $2,$3,$4,$5,$6,$7,$8 }' | sed "s| |.|g" | sed "s|\.\.||g" | sed "s|\.$||g"`"
				echo "$hostname3,$ipaddress2,$FQDN2,$domain3"
			else
				echo -e ",$hostname,\"NSLOOKUP NOT FOUND\","
			fi
		fi
	done | tee -a output.txt
	
done
printf "\n\n\n"
cat output.txt | tee -a output.csv
#grep -v "^," | tr "," " " | awk '{ print $1,$2,$3,$4 }' | tr " " "," 
if [ -e output.txt ]; then 
	rm -f output.txt
fi
