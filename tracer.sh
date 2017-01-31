#!/usr/local/bin/bash
PATH="/bin:/usr/bin:/usr/local/bin:$PATH"

trap 'echo killsignal received' SIGTERM SIGINT

##################################
# CONFIGURATION
SCRIPT_DIR=`dirname $0`
. "${SCRIPT_DIR}/config"
NOW_UNIX=$(date +%s)
NOW_HUMAN=$(date "+%F %H:%M:%S")
RAND=0; while [ "$RAND" -le 1 ];do RAND=$RANDOM; let "RAND %= 1000";done
MACHINE=$(hostname)
LOGFILE_TEMP="${LOGFILE}.${NOW_UNIX}.${RAND}"
PUSHOVER_URL="https://api.pushover.net/1/messages.json"

touch ${SCRIPT_DIR}/log-error.log
exec 2> >(logger -f ${SCRIPT_DIR}/log-error.log) 


exit_program() {
  w >> $LOGFILE_TEMP
  echo $1 >> $LOGFILE_TEMP
  echo "==========================================================" >> $LOGFILE_TEMP
  cat $LOGFILE_TEMP >> $LOGFILE
  rm -f $LOGFILE_TEMP
  exit
}

if [ ! -z "$PAM_USER" ]; then
  USER=$PAM_USER
elif [ -z "$USER" ]; then
  USER="UKN"
fi

if [ ! -z "$PAM_SERVICE" ]; then   
  SERVICE="$PAM_SERVICE"
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

cat <<EOF >> $LOGFILE_TEMP
Service: ${SERVICE}
Action: ${ACTION}
Date: ${NOW_HUMAN}
Server: ${MACHINE}
User: ${USER}
EOF

if [ ! -z "$PAM_RHOST" ]; then
  IP=`host -W5 -t A $PAM_RHOST | awk '{ print $4 }'`

  echo "User Host: ${PAM_RHOST}" >> $LOGFILE_TEMP
  echo "User IP: $IP" >> $LOGFILE_TEMP
fi


if [ "${ACTION}" == "Logout" ] && [ "${LOGOUT_NOTIFICATION}" == "NO" ]; then
  exit_program "Logout END - skipping pushover notification"
fi

##################################
# PUSHOVER
PUSHOVER_TITLE=$TITLE
PUSHOVER_MESSAGE=$(cat $LOGFILE_TEMP)
curl -s -F "token=${PUSHOVER_TOKEN_APP}" -F "user=${PUSHOVER_TOKEN_USER}" -F "title=${PUSHOVER_TITLE}" -F "message=${PUSHOVER_MESSAGE}" ${PUSHOVER_URL} >> ${LOGFILE} 2>&1

exit_program "${ACTION} END"
