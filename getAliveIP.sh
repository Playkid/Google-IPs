#!/usr/bin/bash

####################
#
# only for fun, sometimes the G service is not stable from extracted IP address.
# not figure out yet why it happens... firwall? 
#
# if any bug, feel feel to contact yongjie.gong@gmail.com
####################

command=`which curl`
[ $? -ne 0 ] && echo "can't find curl, exiting..." && exit 1

[ ! -x "$command" ] && echo "$command is not executable, exiting." && exit 1

curl --max-time 16 --connect-timeout 10 -o README.md https://github.com/Playkid/Google-IPs/blob/master/README.md 
[ $? -ne 0 ] && echo "download IP source file failed" && exit 1
echo "download README.md success..."
echo

grep http README.md  | grep "<td>" | awk -F">" '{print $3}' | sed 's/[^0-9|.]//g' > ./ip.log


[ ! -f ./ip.log ] && echo "generate ip.log failed" && exit 1
echo "parse ip address success"

while read ip 
do

	speed=`curl --max-time 10 --connect-timeout 2 -r 0-204800 -L -w %{speed_download} -o/dev/null -s "$ip"`
	ret=$?
	
	if [ $ret -eq 0 ];then
	    curl --max-time 10 --connect-timeout 2 "http://$ip/#newwindow=1&q=linux" > /dev/null 2>&1
		ret=$?

		if [ $ret -eq 0 ];then
			echo "" 
			echo "speed:$speed (byte/second) from $ip "
		fi
    fi 

	echo -n "."

done < ./ip.log
