#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)
if [ -f ${SCRIPT_DIR}/config ];then
	. "${SCRIPT_DIR}/config"
else
	echo "ERROR: Not able to read configuration \"${SCRIPT_DIR}/config\""
	exit 1
fi

NOW_UNIX=$(/usr/bin/env date +%s)
NOW_HUMAN=$(/usr/bin/env date "+%F %H:%M:%S")
MACHINE=$(hostname)
 
LOGFILE_TEMP="${LOGFILE}.${NOW_UNIX}.${RANDOM}"


exit_program() {
  /usr/bin/env w >> ${LOGFILE_TEMP}
  echo $1 >> ${LOGFILE_TEMP}
  echo "==========================================================" >> ${LOGFILE_TEMP}
  cat ${LOGFILE_TEMP} >> ${LOGFILE}
  rm -f ${LOGFILE_TEMP}
  exit
}

if [ ! -z "${PAM_USER}" ]; then
  USER=${PAM_USER}
elif [ -z "${USER}" ]; then
  USER="UKN"
fi

if [ ! -z "${PAM_SERVICE}" ]; then   
  SERVICE="${PAM_SERVICE}"
else
  SERVICE="Manual"
fi

if [ "${PAM_SM_FUNC}" == "pam_sm_open_session" ]; then
  ACTION="Login"
elif [ "${PAM_SM_FUNC}" == "pam_sm_close_session" ]; then
  ACTION="Logout"
elif [ ! -z "${PAM_SM_FUNC}" ]; then
  ACTION="${PAM_SM_FUNC}"
else
  ACTION="TERM EXEC"
fi


echo "Service: ${SERVICE}" >> ${LOGFILE_TEMP}
echo "Action: ${ACTION}" >> ${LOGFILE_TEMP}
echo "Date: ${NOW_HUMAN}" >> ${LOGFILE_TEMP}
echo "Server: ${MACHINE}" >> ${LOGFILE_TEMP}
echo "User: ${USER}" >> ${LOGFILE_TEMP}

if [ ! -z "${PAM_RHOST}" ]; then
  IP=`${HOST} -W5 -t A ${PAM_RHOST} | /usr/bin/env awk '{ print $4 }'`

  echo "User Host: ${PAM_RHOST}" >> ${LOGFILE_TEMP}
  echo "User IP: ${IP}" >> ${LOGFILE_TEMP}
fi


if [ "${ACTION}" == "Logout" ] && [ "${LOGOUT_NOTIFICATION}" == "NO" ]; then
  exit_program "Logout END - skipping pushover notification"
fi

MESSAGE_TITLE=${TITLE}
MESSAGE=$(cat $LOGFILE_TEMP)
for TYPE in $(echo ${NOTIFY_TYPE});do
	if [ -f ${SCRIPT_DIR}/${TYPE}.sh ];then
		echo "${SCRIPT_DIR}/${TYPE}.sh" >> ${LOGFILE_TEMP}
		${SCRIPT_DIR}/${TYPE}.sh "${MESSAGE_TITLE}" "${MESSAGE}"
	else
		echo "ERROR: Message module \"${SCRIPT_DIR}/${TYPE}.sh\" can not be loaded."
	fi
done

exit_program "${ACTION} END"
