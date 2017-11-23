#!/usr/bin/env bash
set -euxo pipefail

# todo: find out how to send emails (SES) and allow sending cron-results via email?
# on how cron.hourly works: https://askubuntu.com/a/611430/389617
# cat << EOF > /etc/cron.hourly/99piwik
# /usr/bin/php /usr/share/nginx/piwik/console core:archive >> /var/log/nginx/piwik.core.archive.log
# EOF
# chmod +x /etc/cron.hourly/99piwik

# every hour + some random seconds : core:archive
# Warning: Resets the current crontab (on purpose)
(echo "1,31 * * * * sleep \$(shuf -i 1-300 -n 1) ; /usr/bin/php /usr/share/nginx/piwik/console core:archive --php-cli-options='-d memory_limit=1536M' >> /var/log/nginx/piwik.core.archive.log") | crontab -u nginx -

# every minute : queuedtracking:process
(crontab -u nginx -l 2>/dev/null; echo "*/1 * * * * /usr/bin/php /usr/share/nginx/piwik/console queuedtracking:process >> /var/log/nginx/piwik.queuedtracking.process.log") | crontab -u nginx -

echo -e "Current contents of /var/spool/cron/nginx: \nSTART\n$(cat /var/spool/cron/nginx)\nEND"