#!/bin/bash


############################################################
#   Log Scraper
#
#   Place script in the same directory as the apache log you would 
#   like processed. The script uses a series of greps and awks
#   to retrieve specific count information.
#   By: Michael Sanderson


othercount=0    #Do this, otherwise if nothing happens, the variable will print blank
notwo=0

### Total Numbers ###

fetched=`grep "/production/file_metadata/modules/ssh/sshd_config" puppet_access_ssl.log | grep GET | wc -l`
put=`grep "/dev/report" puppet_access_ssl.log | grep PUT |wc -l`

#####################


### Conditional Counts ###

for i in `grep "/production/file_metadata/modules/ssh/sshd_config" puppet_access_ssl.log|grep GET | awk -F' ' '{ print $9 }'`
do

if [ $i != 200 ];   #If the value of 'i' is not 200 for the specific path
then
othercount=$(expr $othercount + 1 )
fi
done


for i in `awk -F' ' '{ print $9 }' puppet_access_ssl.log` #Total count of non 200 codes
do
if [ $i != 200 ];
then
notwo=$(expr $notwo + 1 )
fi
done

###############################

### Verbiage ###
echo;echo;echo "Number of times \"/production/file_metadata/modules/ssh/sshd_config\" was fetched: ${fetched}"
echo "Pssst...fyi ${othercount} of those were NOT 200 OK"
echo "In fact, out of ALL requests, ${notwo} were NOT 200 OK";echo;echo

echo "Number of times PUT request sent per IP";echo

echo "Count | IP";echo
grep "/dev/report" puppet_access_ssl.log | grep PUT | awk '{ print $1 }' |sort -n | uniq -c
