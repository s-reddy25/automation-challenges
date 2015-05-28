#!/bin/bash

###################################################################
#   Script to update and distribute file
#
#   Ideally, this script should be run on a series of servers that
#   utilize ssh keys to avoid a password prompt for every server,
#   however, the script will still work with the password prompt
#   and will register a failure to log in to a server as a failed 
#   update attempt. This script takes a file (server_update_list) as input. 
#   Place this file, along with the tempplate.file in the same directory
#   as this script.Create this file as a list of IP addresses 
#   targeted for the updated file. The script will iterate throught 
#   the list, retrieving the facter value from the remote server, 
#   updating the file locally and then scp'ing the file to the remote machine.
#   By: Michael Sanderson

### Initialize success and fail variables to avoid printing a blank
success=0
fail=0
###


for server in `cat server_update_list`      #This loops through the list of IPs
do
widget=`ssh -f root@$server 'mkdir -p /etc/widgetfile;facter -p widget'`   #Remotely retrieve facter value from machine

if [[ -n $widget && $? -eq 0 ]]; then   #Make sure there is a value for widget and ssh fork exited clean

sed -i "s/widget_type\ .*/widget_type $widget/g" /root/template.file   #switch widget_type with acquired value
scp template.file root@$server:/etc/widgetfile/
success=$(expr $success + 1)  #Increase successful counter

else                #Either widget was empty or there was an error with ssh (both instances constitute a failure to update)

fail=$(expr $fail + 1)      #Increase failed counter
echo $server >> /tmp/failed_servers.tmp

fi

done

echo "Number of successful attempts: ${success}"
echo "Number of failed attempts: ${fail}"
echo "Here is a list of the server(s) that failed:"
cat /tmp/failed_servers.tmp
rm -f /tmp/failed_servers.tmp
