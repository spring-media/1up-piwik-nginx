#!/usr/bin/env bash
set -euo pipefail

# todo: find out how to send emails (SES) and allow sending cron-results via email?
# on how cron.hourly works: https://askubuntu.com/a/611430/389617
SCRIPT='/etc/cron.hourly/99piwik'
cat << EOF > ${SCRIPT}
/usr/bin/php /usr/share/nginx/piwik/console core:archive >> /var/log/piwik.core.archive.log
EOF
chmod +x ${SCRIPT}