#! /bin/bash
#    Purpose: This script will refresh the certificate on Oracle Linux servers which is needed for patching.
#     Author: Edward Hunt
#       Date: February 15, 2020
# Directions: Perform "chmod +x" to make this script executable.

cp /usr/share/rhn/ULN-CA-CERT /usr/share/rhn/ULN-CA-CERT.old
wget https://linux-update.oracle.com/rpms/ULN-CA-CERT.sha2
cp ULN-CA-CERT.sha2 /usr/share/rhn/ULN-CA-CERT
yum repolist
