#!/usr/bin/bash

INTERVAL=5
echo Recording from Papouch every $INTERVAL\ seconds.
echo Divide speeds by 10 to get m/s.
echo

mkdir -p data
mkdir -p data/xml

while ( true )
do
	DT=$( /usr/bin/date +%Y-%m-%d-%H-%M-%S )
	DR=$( /usr/bin/date +"%Y-%m-%d %H:%M:%S" )
	wget http://192.168.1.254/fresh.xml -O data/xml/${DT}.xml
	( 
	 echo -en $DR\\t 
	 cat data/xml/${DT}.xml | sed 's/^M$//' | grep sns | sed -r 's/.*type="6".*val="([0-9]+)".*vals="([A-Z]+)".*type="7".*val="([0-9]+)".*/dir \1\t\2\tspd\t\3/' 
	) | tee -a data/log.txt
	sleep $INTERVAL
done
