#!/usr/bin/env bash
set -euo pipefail

# todo: find out how to send emails (SES) and allow sending cron-results via email?
# on how cron.hourly works: https://askubuntu.com/a/611430/389617
cat << EOF > /etc/cron.hourly/99piwik
/usr/bin/php /usr/share/nginx/piwik/console core:archive >> /var/log/piwik.core.archive.log
EOF
chmod +x /etc/cron.hourly/99piwik

(crontab -u nginx -l 2>/dev/null; echo "*/1 * * * * /usr/bin/php /usr/share/nginx/piwik/console queuedtracking:process >> /var/log/piwik.queuedtracking.process.log") | crontab -u nginx -

EOF
chmod +x ${SCRIPT}