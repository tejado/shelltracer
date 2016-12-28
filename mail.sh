#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)
if [ -f ${SCRIPT_DIR}/config ];then
	. "${SCRIPT_DIR}/config"
else
	echo "ERROR: Not able to load configuration \"${SCRIPT_DIR}/config\""
	exit 1
fi

MAIL_TITLE="$1"
MAIL_MESSAGE="$2"

echo "${MAIL_MESSAGE}" | mail -s "${MAIL_TITLE}" ${EMAIL} >${LOGFILE} 2>&1
echo >> ${LOGFILE}

