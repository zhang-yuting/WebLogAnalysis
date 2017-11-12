#!/bin/bash

#Using current directory log files to count web request numbers by hour.
#Version 0.1
#mailto:zhang_q_h@126.com

#Using file name pattern for app type.like TABPM,WEBSITE*.log
#Include some datetime in pattern. like TABPM_2017.05*.log
#The file name pattern case sensitive.
#Default is none,all log files.
#Support regular expression.
FILE_PATTERN="*.log"

#Stat start date format like 2017-06-02.default is last 30 days.
START_DATE=`date -d "-30 day" +%F`

#All temp file dir.
TMP_DIR=/tmp

#Max stat thread numbers.
THREAD_NUMS=8

while getopts ":t:s:e" arg
do
        case $arg in
             t)
		[ -n $OPTARG ] && FILE_PATTERN=${OPTARG}
                ;;
             s)
		if [ -n $OPTARG ]; then
		
			if 
				START_DATE=`date -d "$OPTARG" +%F`
			then
				echo ""
			else
				echo "Start date format error(-s):$OPTARG"
				exit 1
			fi 	
		fi
                ;;
             ?)
                echo "unkonw argument"
                exit 1
                ;;
        esac
done

LOGFILE_NAMES=`ls -t | grep -E "$FILE_PATTERN"`
LOGFILE_NUMS=`ls -l | grep -E "$FILE_PATTERN" -c`

[ $LOGFILE_NUMS -eq 0 ] && echo "Not found any logs with pattern(-t):$FILE_PATTERN" && exit 1

#Prepare fifo for multi threads.
TMPFIFO=$TMP_DIR/logstat_tmpfifo.$$
touch $TMPFIFO
mkfifo $TMPFIFO
exec 6<>$TMPFIFO
for ((i=0;i<$THREAD_NUMS;i++))
do
    echo -ne "\n" 1>&6
done

#Count all request numbers
REQ_CACHE=$TMP_DIR/logstat_req_cache.$$
for fn in $LOGFILE_NAMES
do
{
	read -u 6
	{
		awk -F: '{split($1,a,"[");hours[a[2]":"$2]++}END{for(h in hours){print h,hours[h]}}' $fn >> $REQ_CACHE
		echo -ne "\n" 1>&6
	}&
}
done
wait

#Generate and format data.
COUNT_DAYS=0
FIN_TS=`date +%s`
CUR_TS=`date -d "-$COUNT_DAYS day $START_DATE" +%s`

while [ $CUR_TS -le $FIN_TS ]
do
	cur_date=`date -d @$CUR_TS +%d/%b/%Y`	
	for h in `seq 0 23`
	do
		cur_hour="$cur_date:$(printf %02d $h)"
		req_count=0
		for req_nums in `grep $cur_hour $REQ_CACHE | awk '{print $2}'`
		do
			req_count=$(($req_count+$req_nums))
		done
		echo "$cur_hour,$req_count"
	done	

	COUNT_DAYS=$(($COUNT_DAYS+1))
	CUR_TS=`date -d "+$COUNT_DAYS day $START_DATE" +%s`
done

rm -f $REQ_CACHE
rm -f $TMPFIFO
