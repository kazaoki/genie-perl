#!/bin/sh

. /root/.bashrc
cd /turnip/
bundle exec rspec --color $@
