#!/bin/bash
daemonize -o /opt/back-end/logs/hram-stdout -e /opt/back-end/logs/hram-stderr -p /opt/back-end/logs/hram-pid /opt/java/openjdk/bin/java -jar /opt/back-end/business-logic-0.0.1-SNAPSHOT.jar --spring.profiles.active=docker && tail /opt/back-end/logs/hram-stdout -f
