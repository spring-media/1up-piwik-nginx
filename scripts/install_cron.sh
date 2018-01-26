#!/usr/bin/env bash
set -euo pipefail


# every hour + some random seconds : core:archive
# Warning: Resets the current crontab (on purpose)
(echo "*/30 * * * * sleep \$(shuf -i 1-300 -n 1) ; /usr/bin/php /usr/share/nginx/piwik/console core:archive --php-cli-options='-d memory_limit=1536M' >> /var/log/nginx/piwik.core.archive.log 2>&1") | crontab -u nginx -

# nightly delete old logs: https://matomo.org/faq/how-to/faq_20184/
(crontab -u nginx -l 2>/dev/null; echo "17 0 * * * sleep $(shuf -i 1-3600 -n 1) ; /usr/bin/php /usr/share/nginx/piwik/console core:delete-logs-data --dates=2017-01-01,$(date --date='7 days ago' +'%Y-%m-%d') --optimize-tables --no-interaction -v >> /var/log/nginx/piwik.core.delete-logs.log 2>&1") | crontab -u nginx -

# every minute : queuedtracking:process
(crontab -u nginx -l 2>/dev/null; echo "*/1 * * * * /opt/piwik-nginx/scripts/queued_tracking.sh >> /var/log/nginx/piwik.queuedtracking.cron.log 2>&1") | crontab -u nginx -

echo -e "Current contents of /var/spool/cron/nginx: \nSTART\n$(cat /var/spool/cron/nginx)\nEND"