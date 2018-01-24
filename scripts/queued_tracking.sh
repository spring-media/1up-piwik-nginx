#!/usr/bin/env bash

COMMAND="/usr/bin/php /usr/share/nginx/piwik/console queuedtracking:process"
OUTPUT_PREFIX="/var/log/nginx/piwik.queuedtracking.process"

CPU_COUNT=$(lscpu -p | egrep -v '^#' | wc -l)

for i in $(seq 1 $CPU_COUNT); do
    PIDFILE=/tmp/queuedtracking.$i.pid

    if [ -f $PIDFILE ]; then
        PID=$(cat $PIDFILE)
        ps -p $PID > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "Job $i is already running"
            exit 1
        else
            ## Process not found assume not running
            echo $$ > $PIDFILE
            if [ $? -ne 0 ]; then
                echo "Could not create PID file"
                exit 1
            fi
        fi
        else
        echo $$ > $PIDFILE
        if [ $? -ne 0 ]; then
            echo "Could not create PID file"
            exit 1
        fi
    fi
    
    START=$(date +%s.%N)
    $COMMAND >> $OUTPUT_PREFIX.$i.log
    END=$(date +%s.%N)
    DIFF=$(echo "$END - $START" | bc)
    echo "`date +%F\ %T` Finished QueuedTracking $i — took $DIFF seconds"
    rm $PIDFILE
done