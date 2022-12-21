#! /bin/bash
#
#Use storage class ibmc-file-gold-gid when running on ROKS clusters
#Use storage class ocs-storagecluster-ceph-rbd when running on CoC PoT clusters
#mq00 reserved for instructor
#
# This script will create the 4th Qmgr for the UniCluster lab.
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
#
# Set variables
#
export TARGET_NAMESPACE=$namespace
export QMpre="mq"$student
export QMnamed="mq"$student"d"
export CONNAMEd="mq"$student"d-ibm-mq"
export SERVICEd="mq"$student"d-ibm-mq"
export CHANNELd="mq"$student"chld"
export TOCLUSd="TO_UNICLUS_mq"$student"d"
export UNICLUS=UNICLUS"$student"
export SC=ocs-storagecluster-ceph-rbd
#export SC=ibmc-file-gold-gid
export VERSION=9.3.0.0-r2

( echo "cat <<EOF" ; cat uniaddqmgr.yaml_template ; echo EOF ) | sh > uniaddqmgr.yaml

oc apply -f uniaddqmgr.yaml  -n $TARGET_NAMESPACE
