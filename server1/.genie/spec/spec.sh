#!/bin/sh

# spec.sh version 0.4.7 + a

SPEC_PATH="$(cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")"; pwd)"

# --------------------------------------------------------------------
# setting
# --------------------------------------------------------------------
# [general]
SPEC_CONTAINER="spec-kantaro-3rd"
SPEC_LOCAL_DIR="${SPEC_PATH}"
SPEC_TARGET_DIR="features"
SPEC_HTML_REPORT="${SPEC_HTML_REPORT:-1}"
SPEC_JS_ERRORS="${SPEC_JS_ERRORS:-1}"
SPEC_CAPTURE_WIDTH=1200
#SPEC_USER_AGENT="Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.107 Safari/537.36"
#SPEC_COMMAND_BEFORE="echo === start ==="
#SPEC_COMMAND_AFTER="echo === finish ==="

# [hosts]
`type docker-machine >/dev/null 2>&1`
if [ $? == 0 ]; then
  # -- for docker-machine
  DOCKER_HOST_IP=$(docker-machine ip default)
else
  `type ip >/dev/null 2>&1`
  if [ $? == 0 ]; then
    # -- use ip command
    DOCKER_HOST_IP=$(ip -f inet a show $(ip r | grep 'default' | awk '{print $5}') | grep 'inet' | awk '{print $2}' | sed -e 's/\/.*//g')
  else
    # -- manual
    DOCKER_HOST_IP='192.168.0.100'
  fi
fi
SPEC_HOSTS="$DOCKER_HOST_IP kantaro-cgi.com"

# --------------------------------------------------------------------
# cli
# --------------------------------------------------------------------
if [[ $1 == "cli" ]]; then

  docker rm -f $SPEC_CONTAINER >/dev/null 2>&1
  docker run -it --rm \
    -e SPEC_CONTAINER="$SPEC_CONTAINER" \
    -e SPEC_HOSTS="$SPEC_HOSTS" \
    -e SPEC_TARGET_DIR="$SPEC_TARGET_DIR" \
    -e SPEC_USER_AGENT="$SPEC_USER_AGENT" \
    -e SPEC_HTML_REPORT=$SPEC_HTML_REPORT \
    -e SPEC_JS_ERRORS=$SPEC_JS_ERRORS \
    -e SPEC_CAPTURE_WIDTH=$SPEC_CAPTURE_WIDTH \
    -e SPEC_CLI=1 \
    -e TERM="xterm" \
    -v $SPEC_LOCAL_DIR:/opt/spec \
    -v $SPEC_LOCAL_DIR/confs/spec_helper.rb:/turnip/spec/spec_helper.rb \
    --name=$SPEC_CONTAINER \
    kazaoki/spec

  exit 0
fi

# --------------------------------------------------------------------
# rspec run all
# --------------------------------------------------------------------
if [[ $1 == "all" ]]; then

  if [[ $SPEC_COMMAND_BEFORE != "" ]]; then
    eval $SPEC_COMMAND_BEFORE
  fi

  docker rm -f $SPEC_CONTAINER >/dev/null 2>&1
  docker run -t --rm \
    -e SPEC_CONTAINER="$SPEC_CONTAINER" \
    -e SPEC_HOSTS="$SPEC_HOSTS" \
    -e SPEC_TARGET_DIR="$SPEC_TARGET_DIR" \
    -e SPEC_USER_AGENT="$SPEC_USER_AGENT" \
    -e SPEC_HTML_REPORT=$SPEC_HTML_REPORT \
    -e SPEC_JS_ERRORS=$SPEC_JS_ERRORS \
    -e SPEC_CAPTURE_WIDTH=$SPEC_CAPTURE_WIDTH \
    -e TERM="xterm" \
    -v $SPEC_LOCAL_DIR:/opt/spec \
    -v $SPEC_LOCAL_DIR/confs/spec_helper.rb:/turnip/spec/spec_helper.rb \
    --name=$SPEC_CONTAINER \
    kazaoki/spec

  SPEC_RESULT=$?

  if [[ $SPEC_COMMAND_AFTER != "" ]]; then
    eval $SPEC_COMMAND_AFTER
  fi

  exit $SPEC_RESULT
fi

# --------------------------------------------------------------------
# rspec run specific feature files
# --------------------------------------------------------------------
if [[ $1 != "" ]]; then

  if [[ $SPEC_COMMAND_BEFORE != "" ]]; then
    eval $SPEC_COMMAND_BEFORE
  fi

  docker rm -f $SPEC_CONTAINER >/dev/null 2>&1
  docker run -t --rm \
    -e SPEC_CONTAINER="$SPEC_CONTAINER" \
    -e SPEC_HOSTS="$SPEC_HOSTS" \
    -e SPEC_TARGET_DIR="$SPEC_TARGET_DIR" \
    -e SPEC_USER_AGENT="$SPEC_USER_AGENT" \
    -e SPEC_HTML_REPORT=$SPEC_HTML_REPORT \
    -e SPEC_JS_ERRORS=$SPEC_JS_ERRORS \
    -e SPEC_CAPTURE_WIDTH=$SPEC_CAPTURE_WIDTH \
    -e SPEC_ARGS_FEATURE="$*" \
    -e TERM="xterm" \
    -v $SPEC_LOCAL_DIR:/opt/spec \
    -v $SPEC_LOCAL_DIR/confs/spec_helper.rb:/turnip/spec/spec_helper.rb \
    --name=$SPEC_CONTAINER \
    kazaoki/spec

  SPEC_RESULT=$?

  if [[ $SPEC_COMMAND_AFTER != "" ]]; then
    eval $SPEC_COMMAND_AFTER
  fi

  exit $SPEC_RESULT
fi

# --------------------------------------------------------------------
# show feature files only
# --------------------------------------------------------------------
if [[ $1 == "" ]]; then

  echo
  echo ----------------------------------------
  find "$SPEC_PATH/features" -type f | sed -e "s|^${SPEC_PATH}/features/|  - |g"
  echo
  echo "  ...please specific filename(s) or 'all'  "
  echo ----------------------------------------
  echo

  exit 0
fi

