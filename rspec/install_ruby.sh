#!/bin/bash

set -e

source /etc/profile

RUBY=$(awk '$1 ~ /^ruby$/ {print $2}' < Gemfile | tr -d \'\" )

rvm install ${RUBY}
rvm use --default ${RUBY}
gem install bundler --no-ri --no-rdoc
