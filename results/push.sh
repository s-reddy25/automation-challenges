#!/bin/bash

success=0;
fail=0;

count=`cat ips.txt|wc -l`

echo "Number of servers to push the file are :${count}"

for ip in `cat ips.txt`; do
  echo "working on ip:$ip"
  scp -i key.pem template.file root@${ip}:/etc/widgetfile/;
  exitCode=$?
  if [ $exitCode -eq 0 ]; then
	((success++))
  else
	((fail++))
  fi

done

echo "Total number of servers:$count"
echo "Number of servers with Template:$success"
echo "Number of servers without Template:$fail" 
