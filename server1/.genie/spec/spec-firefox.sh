#!/bin/sh

. /root/.bashrc
export DISPLAY=:99
Xvfb :99 -screen 0 ${GENIE_SPEC_CAPTURE_WIDTH}x1080x24 >/dev/null 2>&1 &
firefox >/dev/null 2>&1 &
cd /turnip/
bundle exec rspec --color $@
killall Xvfb
