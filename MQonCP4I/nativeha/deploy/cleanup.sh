#! /bin/bash
#
# This script will cleanup the UniCluster lab.
#
ERRORMSG1="Error invalid arg:  \n\n
Usage: <script> -i 01 -n melch1 \n
    -i, Student number \n
    -n, Student Namespace"

ERRORMSG2="Missing args:  \n\n
Usage: <script> -i 01 -n melch1 \n
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
export QMname="mq"$student"ha"

oc delete queuemanager $QMname -n $TARGET_NAMESPACE
oc delete secret nativehacert -n $TARGET_NAMESPACE
oc delete configmap nativehamqsc -n $TARGET_NAMESPACE
oc delete pvc data-$QMname-ibm-mq-0 -n $TARGET_NAMESPACE
oc delete pvc data-$QMname-ibm-mq-1 -n $TARGET_NAMESPACE
oc delete pvc data-$QMname-ibm-mq-2 -n $TARGET_NAMESPACE
oc delete route mq-traffic-mq-$QMname-ibm-mq-qm -n $TARGET_NAMESPACE

rm nativeha.yaml
rm ha-install.sh

