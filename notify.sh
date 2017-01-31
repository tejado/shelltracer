#!/usr/bin/env bash

SCRIPT_DIR=`dirname $0`
. "${SCRIPT_DIR}/config"

PUSHOVER_TITLE="$1"
PUSHOVER_MESSAGE="$2"
PUSHOVER_URL="https://api.pushover.net/1/messages.json"

curl -s -F "token=${PUSHOVER_TOKEN_APP}" -F "user=${PUSHOVER_TOKEN_USER}" -F "title=${PUSHOVER_TITLE}" -F "message=${PUSHOVER_MESSAGE}" ${PUSHOVER_URL} >> ${LOGFILE} 2>&1
echo >> ${LOGFILE}
