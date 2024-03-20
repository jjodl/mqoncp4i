#! /bin/bash
#
# This script will cleanup the StreamQ lab.
#
ERRORMSG1="Error invalid arg:  \n\n
Usage: <script> -i 01 -n student1 \n
    -i, Student number \n
    -n, Student Namespace"

ERRORMSG2="Missing args:  \n\n
Usage: <script> -i 01 -n student1 \n
    -i, Student number \n
    -n, Student Namespace"

   while getopts ':i:n:' flag;
     do
       case "${flag}" in
         i) student=${OPTARG};;
         n) namespace=${OPTARG};;
         *) echo -e ${ERRORMSG1}
		exit 1;;
       esac
   done
if [ $OPTIND -ne 5 ]; then
   echo -e ${ERRORMSG2} 
   exit 1
fi
#mq99 reserved for instructor
export TARGET_NAMESPACE=$namespace
export QMInstance=$TARGET_NAMESPACE"-mq"$student"strm"

oc delete queuemanager $QMInstance -n $TARGET_NAMESPACE
oc delete secret streamqqmgrcert -n $TARGET_NAMESPACE
oc delete configmap streamqmqsc -n $TARGET_NAMESPACE
oc delete route $TARGET_NAMEPSPACE-mq-traffic-mq-mq$studentstrm-ibm-mq-qm -n $TARGET_NAMESPACE
oc delete pvc data-$TARGET_NAMESPACE-mq$studentstrm-ibm-mq-0 -n $TARGET_NAMESPACE

rm streamq.yaml
rm strm-install.sh
