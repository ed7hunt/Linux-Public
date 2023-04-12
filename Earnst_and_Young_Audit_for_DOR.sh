# !/bin/bash
# Back in March 2018, Earnst and Young sent me a list of broken commands to audit GA DOR. I corrected all their
# commands and I built a script to run on any server they wanted. Below is the output of this free labor I donated 
# to E&Y on behalf of GA DOR's Cybersecurity Team for E&Y's audit. We never heard back from them and they never
# thanked me or paid back the State of Georgia tax payers for the work I did for them. This was a charity project
# to assist their newly hired analysts.
#
# Therefore, I made this script OPEN-SOURCE and free for anyone to use. Everyone may use this script without mentioning 
# where it came from.

SCRIPT_CONTENTS () {
#Dear Client,

#As part of our current engagement, we are required to review the Red Hat Linux servers. In order to complete our review in a timely manner, please provide the items requested. If you have any questions about the items requested, please notify us as soon as possible.


#Provide a copy of the '/root/.profile' files. These are typically obtained by executing the following command:
  cat /root/.profile > root_profile.txt

#Provide a copy of the '/etc/security/access.conf' file. This is typically obtained by executing the following command:
  cat /etc/security/access.conf > hostname_access_conf.txt

#Provide the umask settings from the '/etc/bashrc' file. This is typically obtained by executing the following command:
  grep umask /etc/bashrc > hostname_bash_umask.txt

#Provide a copy of  the '/etc/profile' file. This is typically obtained by executing the following command:
  cat /etc/profile > hostname_umask.txt

#Provide the umask settings from user's home directories. This is typically obtained by executing the following command:
  grep -r umask /home/ > hostname_umask_users.txt

#Provide a copy of the '/etc/crontab' file. This is typically obtained by executing the following command:
  cat /etc/crontab > hostname_crontab.txt

#Provide the directory listing of '/var/spool/cron/'. This is typically obtained by executing the following command:
  ls -al /var/spool/cron/ > hostname_cron_job.txt

#Provide a copy of the '/etc/fstab' file if an encrypted file system is in use.  This is typically obtained by executing the following command:
  cat  /etc/fstab > etc_fstab.txt

#Provide a copy of the '/etc/ftpaccess' file. This is typically obtained by executing the following command:
  cat /etc/ftpaccess >  hostname_wuftpuser.txt

#Provide a copy of the '/etc/ftpusers' file. This is typically obtained by executing the following command:
  cat /etc/ftpusers > hostname_ftpusers.txt

#Provide the root account group details from the '/etc/group' file. This is typically obtained by executing the following command:
  cat /etc/group | grep root > hostname_root_grp.txt

#Provide a copy of the '/etc/group' file. This is typically obtained by executing the following command:
  cat /etc/group > hostname_etc_group.txt

#Provide a copy of the permissions for the '/etc/hosts.equiv' file. This is typically obtained by executing the following command:
  ls -l /etc/hosts.equiv > hosts_equiv_permissions.txt

#Provide a copy of the '/etc/hosts.equiv' file. This is typically obtained by executing the following command:
  cat /etc/hosts.equiv > hostname_etc_hostsequiv.txt

#Provide a copy of the '/etc/login.defs' files. This is typically obtained by executing the following command:
  cat /etc/login.defs >etc_login_defs.txt
#- Note: Administrator must be logged in as root.

#Provide a copy of the '/etc/login.defs' file. This is typically obtained by executing the following command:
  cat /etc/login.defs > hostname_login_def.txt

#Provide reports of the files relating to the network services. These are typically obtained by executing the following commands:
  chkconfig --list > chkconfig.txt
  lsof | grep LISTEN > lsof.txt 
  ifconfig -a > ifconfig.txt
  IP=$(nslookup `uname -n` | tail -n 2 | head -n 1 | awk '{print $2}')
  nmap $IP > nmap_TCP_$IP.txt
  nmap -sU $IP > nmap_UDP_$IP.txt
#- Note: Use the '/sbin/ifconfig -a' command to determine the IP address.

#Provide a copy of the permissions for the '/etc/security/opasswd' file. This is typically obtained by executing the following command:
  ls -l /etc/security/opasswd > etc_security_opasswd.txt

#Provide a copy of the '/etc/passwd' file. This is typically obtained by executing the following command:
  cat /etc/passwd > hostname_etc_password.txt

#Provide a copy of the '/etc/passwd' file from the system. This is typically obtained by executing the following command:
  cat /etc/passwd > hostname_etc_passwd.txt

#Provide a copy of the '/etc/security/passwd' file. This is typically obtained by executing the following command:
  cat /etc/security/passwd > etc_security_passwd.txt
#- Note: Administrator must be logged in as root.

#Provide the file permission of the '/etc/passwd' file. This is typically obtained by executing the following command:
  ls -al /etc/passwd > hostname_etc_passwd.txt

#Provide a copy of the following files which have information on the PATH variables:
#- Note 1: Root login is required before the following commands are executed:
    cat /.profile  > hostname_root_profile.txt
    cat /home/zedwardh/.profile  > hostname_zedwardh_profile.txt
#- Note 2:  change the username jdoe to an appropriate username in your system

#Provide a copy of the '/etc/pam.d/ppp' file. This is typically obtained by executing the following command:
  cat /etc/pam.d/ppp > hostname_pamd_ppp.txt

#Provide a copy of the '/etc/pam.d/passwd' file. This is typically obtained by executing the following command:
  cat /etc/pam.d/passwd > hostname_pamd_passwd.txt

#Provide a copy of the '/etc/profile' file. This is typically obtained by executing the following command:
  cat /etc/profile > etc_profile.txt

#Provide reports of the files relating to the remote trusted services. These are typically obtained by executing the following commands:
  /sbin/chkconfig --list > services.txt
  cat /etc/xinetd.conf > etc_xinetdconf.txt
  cat /etc/xinetd.d/r* > etc_xinetdd_r.txt
  ls -al /home/* > home_dirs.txt

#Provide a copy of the '/var/log/secure' file. This is typically obtained by executing the following command:
  cat /var/log/secure > hostname_secure_log.txt

#Provide a list of the SGID files. This is typically obtained by executing the following command: 
  find / -user root -type f -perm -2000 -exec ls -al {} \; > hostname_sgid.txt

#Provide a copy of the '/etc/shadow' file. This is typically obtained by executing the following command:
  cat /etc/shadow > hostname_etc_shadow.txt

#Provide the file permission of the '/etc/shadow' file. This is typically obtained by executing the following command:
  ls -l /etc/shadow > hostname_perm_etcshadow.txt

#Provide a copy of the '/etc/shadow' file. This is typically obtained by executing the following command:
  cat /etc/shadow > hostname_etc_shadow.txt

#Provide a copy of the '/etc/shells' file. This is typically obtained by executing the following command:
  cat /etc/shells > hostname_etc_shells.txt

#Provide a list of the SUID files. This is typically obtained by executing the following command: 
  find / -user root -type f -perm -4000 -exec ls -al {} \; > hostname_suid.txt

#Provide a copy of the '/etc/syslog.conf' file. This is typically obtained by executing the following command:
  cat /etc/syslog.conf > hostname_syslog_conf.txt

#Provide a copy of the '/etc/pam.d/system-auth' files. This is typically obtained by executing the following command:
  cat /etc/pam.d/system-auth > etc_pamd_systemauth.txt

#Provide a report listing the permissions of files in the '/var/log/' directory.  This is typically obtained by executing the following commands:
  ls -l  /var/log/ > var_log.txt
  

#Provide a report of the permissions for the '/var/log' file. This is typically obtained by executing the following command:
  ls -lR /var/log/ > var_log_perm.txt

#Provide a listing of the files within the '/var/log' directory. This is typically obtained by executing the following command:
  ls -al /var/log > var_log.txt

#Provide a copy of the '/etc/vsftpd.ftpusers' file. This is typically obtained by executing the following command:
  cat /etc/vsftpd.ftpusers > hostname_vsftpd_ftpusers.txt

#Provide a list of the 'world writable' files in the system. This can be typically obtained by executing the following commands:
  find / -type f -perm -00102 -exec ls -alL {} \; > hostname_wwfile.txt
  chmod 600 hostname_wwfile.txt

#Provide a report listing the permissions of files in the '/etc/pam.d' file.  This is typically obtained by executing the following commands:
  cat /etc/pam.d/login > etc_pamd_login.txt

#Provide a listing of the '/dev' directory by running the following command:
  ls -al /dev > hostname_dev_list.txt

#Provide a listing of all the device files by running the following command:
  find / \( -type c -o -type b \) -exec ls -al {} \; > hostname_unauthorized_dev.txt

#Provide a list of all documented changes that have occurred on this system in the review period. If possible, provide a system-generated list.

#Provide a copy of the hires / leavers list within the review period.

#Provide a copy of the NIS directory listing. This is typically obtained by executing the following command:
  ls -al NIS-directory > hostname_NIS_dir.txt
  echo "NIS is not installed or running on this server." > hostname_NIS_dir.txt

#Provide a copy of the root's home directory listing. These are typically obtained by executing the following commands:
  ls -al /root/.* > hostname_root_dir.txt
  ls -al / >> hostname_root_dir.txt

#Provide the system user access list. This is typically obtained by running the following command:
  cat /etc/passwd > hostname_etc_passwd

#Provide a listing of all the 'world writable' files and directories. This is typically obtained by executing the following commands:
#FILES
   find / -type f -perm 00777 -exec ls -al {} \; > ey.wwfile.txt  
#DIRECTORIES
   find / -type d -perm 00777 -exec ls -al {} \; > ey.wwdir.txt 

#Provide a list of the 'world writable' directories in the system. This can be typically obtained by executing the following commands:
  find / -type d -perm -2 -exec ls -dlL {} \; > hostname_wwdir.txt
  chmod 600 hostname_wwdir.txt

#Provide a report listing files that are open by recording the processes running on the system. This is typically obtained by executing the following command:
  /usr/sbin/lsof | grep LISTEN > lsof.txt 

#Provide a report of the password file inconsistencies by executing the following command:
  /usr/sbin/pwck > password_check.txt

#Provide a report containing the permissions for all files and directories that belong to root and all other user accounts with UID of 0. This is typically obtained by executing the following command:
  find / -user 0 -exec ls -l {} \; > uid0file_perm.txt

#Provide a report of the file permissions for System Utility programs on the system. This is typically obtained by executing the following command:
  find / -type f -perm +1 -exec ls -l {} \; > binaries.txt
#- Note: depending on the environment and applications installed on the AIX server, there may be hundreds or thousands of administrative type utilities (command line and GUI) on the system.

#Provide a report of all world writable files and directories. These are typically obtained by executing the following commands:
#FILES
   find / -type f -perm 00777 -exec ls -al {} \; > ey.wwfile
#DIRECTORIES
   find / -type d -perm 00777 -exec ls -al {} \; > ey.wwdir

#Thank you for your assistance. Please contact our team if you have any questions.

#Regards,
#Ernst & Young, LLP
}

mkdir -p /root/`uname -n`_`date +%Y_%B_%d`
pushd /root/`uname -n`_`date +%Y_%B_%d`
SCRIPT_CONTENTS
popd
tar -cvf /root/`uname -n`_`date +%Y_%B_%d`.tar /root/`uname -n`_`date +%Y_%B_%d`
gzip /root/`uname -n`_`date +%Y_%B_%d`.tar
