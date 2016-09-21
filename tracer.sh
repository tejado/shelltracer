#!/bin/sh

SCRIPT_DIR=`dirname $0`
. "${SCRIPT_DIR}/config"

NOW_UNIX=`${DATE} +%s`
NOW_HUMAN=`${DATE} "+%F %H:%M:%S"`
RAND=`${JOT} -r 1 1000`
MACHINE=`hostname`
 
LOGFILE_TEMP="${LOGFILE}.${NOW_UNIX}.${RAND}"


exit_program() {
  ${W} >> $LOGFILE_TEMP
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


echo "Service: ${SERVICE}" >> $LOGFILE_TEMP
echo "Action: ${ACTION}" >> $LOGFILE_TEMP
echo "Date: ${NOW_HUMAN}" >> $LOGFILE_TEMP
echo "Server: ${MACHINE}" >> $LOGFILE_TEMP
echo "User: ${USER}" >> $LOGFILE_TEMP

if [ ! -z "$PAM_RHOST" ]; then
  IP=`${HOST} -W5 -t A $PAM_RHOST | ${AWK} '{ print $4 }'`

  echo "User Host: ${PAM_RHOST}" >> $LOGFILE_TEMP
  echo "User IP: $IP" >> $LOGFILE_TEMP
fi


if [ "${ACTION}" == "Logout" ] && [ "${LOGOUT_NOTIFICATION}" == "NO" ]; then
  exit_program "Logout END - skipping pushover notification"
fi

PUSHOVER_TITLE=$TITLE
PUSHOVER_MESSAGE=`cat $LOGFILE_TEMP`
${SCRIPT_DIR}/notify.sh "${PUSHOVER_TITLE}" "${PUSHOVER_MESSAGE}"

exit_program "${ACTION} END"
