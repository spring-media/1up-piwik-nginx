yum install perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https -y

adduser --home-dir /opt/aws-scripts-mon --no-create-home --system  --shell /sbin/nologin monitoring

cd /opt
curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
unzip CloudWatchMonitoringScripts-1.2.1.zip
chown -R monitoring aws-scripts-mon
rm CloudWatchMonitoringScripts-1.2.1.zip

echo "*/5 * * * * /opt/aws-scripts-mon/mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --mem-avail --mem-used --disk-space-avail --disk-space-used --disk-space-util --disk-path=/ --from-cron" | crontab -u monitoring -