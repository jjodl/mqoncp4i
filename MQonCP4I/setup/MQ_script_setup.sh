#! /bin/bash
#
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
unicluster/uni-install-create.sh $namespace $student
unicluster/uni-addqmgr-create.sh $namespace $student
streamq/strm-create.sh $namespace $student
nativeha/nativeha-create.sh $namespace $student





