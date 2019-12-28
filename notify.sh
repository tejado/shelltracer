#!/bin/sh

SCRIPT_DIR=`dirname $0`
. "${SCRIPT_DIR}/config"

PUSHOVER_TITLE="$1"
PUSHOVER_MESSAGE="$2"
PUSHOVER_URL="https://api.pushover.net/1/messages.json"

${CURL} -s -F "token=${PUSHOVER_TOKEN_APP}" -F "user=${PUSHOVER_TOKEN_USER}" -F "title=${PUSHOVER_TITLE}" -F "message=${PUSHOVER_MESSAGE}" ${PUSHOVER_URL} >> ${LOGFILE} 2>&1

if [ $USE_TELEGRAM = "YES" ]; then
    telegram-cli -W -e "msg $TELEGRAM_ACCOUNT_NAME $PUSHOVER_MESSAGE" >> ${LOGFILE} 2>&1
fi

echo >> ${LOGFILE}
