#!/usr/bin/bash

INTERVAL=60
echo Recording from Papouch every $INTERVAL\ seconds.
echo Divide speeds by 10 to get m/s.
echo

DD=papouch
XML=$DD/xml
mkdir -p $DD
mkdir -p $XML

while ( true )
do
	DT=$( /usr/bin/date +%Y-%m-%d-%H-%M-%S )
	DR=$( /usr/bin/date +"%Y-%m-%d %H:%M:%S" )
	wget http://192.168.1.254/fresh.xml -O $XML/${DT}.xml
	( 
	 echo -en $DR\\t 
	 cat $XML/${DT}.xml | sed 's/^M$//' | grep sns | sed -r 's/.*type="6".*val="([0-9]+)".*vals="([A-Z]+)".*type="7".*val="([0-9]+)".*/dir \1\t\2\tspd\t\3/' 
	) | tee -a $DD/log.txt
	sleep $INTERVAL
done
