#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)
if [ -f ${SCRIPT_DIR}/config ];then
	. "${SCRIPT_DIR}/config"
else
	echo "ERROR: Not able to load configuration \"${SCRIPT_DIR}/config\""
	exit 1
fi

PUSHOVER_TITLE="$1"
PUSHOVER_MESSAGE="$2"
PUSHOVER_URL="https://api.pushover.net/1/messages.json"

/usr/bin/env curl -s -F "token=${PUSHOVER_TOKEN_APP}" -F "user=${PUSHOVER_TOKEN_USER}" -F "title=${PUSHOVER_TITLE}" -F "message=${PUSHOVER_MESSAGE}" ${PUSHOVER_URL} >> ${LOGFILE} 2>&1
RC=$?
if [ ! ${RC} -eq 0 ];then
	echo "ERROR: Not able to push pushover message" >>${LOGFILE}
	exit 1
fi
echo >> ${LOGFILE}
