#!/usr/bin/env bash

PIDFILE=/tmp/core:delete-logs.pid

if [ -f $PIDFILE ]; then
    PID=$(cat $PIDFILE)
    ps -p $PID > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Job is already running"
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

echo "Starting core:delete-logs"
sleep $(shuf -i 1-3600 -n 1)
START=$(date +%s.%N)
/usr/bin/php /usr/share/nginx/piwik/console core:delete-logs-data \
    --php-cli-options='-d memory_limit=1536M' \
    --dates=2017-01-01,$(date --date='7 days ago' +'%Y-%m-%d') \
    --optimize-tables \
    --no-interaction -v >> /var/log/nginx/piwik.core.delete-logs.log
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "`date +%F\ %T` Finished core:delete-logs — took $DIFF seconds"
rm $PIDFILE