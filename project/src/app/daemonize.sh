#!/bin/bash
useradd --no-create-home nginx
/usr/sbin/nginx -g "daemon off;"
#/opt/back-end/daemonize1.sh
#java -jar /opt/back-end/business-logic-0.0.1-SNAPSHOT.jar --spring.profiles.active=docker &
#daemonize -o /opt/back-end/logs/hram-stdout -e /opt/back-end/logs/hram-stderr -p /opt/back-end/logs/hram-pid /opt/java/openjdk/bin/java -jar /opt/back-end/business-logic-0.0.1-SNAPSHOT.jar --spring.profiles.active=docker && tail /opt/back-end/logs/hram-stdout -f
exit 0