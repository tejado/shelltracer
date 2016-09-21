#!/bin/sh

SCRIPT_DIR=`dirname $0`

/usr/bin/nohup ${SCRIPT_DIR}/tracer.sh > ${SCRIPT_DIR}/log-error.log 2>&1 &
