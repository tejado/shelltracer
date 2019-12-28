#!/bin/sh

SCRIPT_DIR=`dirname $0`
. "${SCRIPT_DIR}/config"

PUSHOVER_TITLE="$1"
PUSHOVER_MESSAGE="$2"
FILE_TO_SEND="$3"
PUSHOVER_URL="https://api.pushover.net/1/messages.json"

${CURL} -s -F "token=${PUSHOVER_TOKEN_APP}" -F "user=${PUSHOVER_TOKEN_USER}" -F "title=${PUSHOVER_TITLE}" -F "message=${PUSHOVER_MESSAGE}" ${PUSHOVER_URL} >> ${LOGFILE} 2>&1

if [ $USE_TELEGRAM = "YES" ]; then
    cd /etc/telegram-cli && telegram-cli -W server.pub -e "send_text $TELEGRAM_ACCOUNT_NAME $FILE_TO_SEND" >> ${LOGFILE} 2>&1
fi

echo >> ${LOGFILE}
