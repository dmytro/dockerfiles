#!/bin/bash

source /etc/profile
Xvfb :99 -ac &
export DISPLAY=:99
#java -jar /opt/selenium/selenium-server-standalone.jar 2>&1 &
#DISPLAY=:99 firefox 2>/dev/null >/dev/null &

bundle exec rspec
