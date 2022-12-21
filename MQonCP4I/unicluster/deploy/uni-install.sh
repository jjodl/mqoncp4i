#! /bin/bash
#
#Use storage class ibmc-file-gold-gid when running on ROKS clusters
#Use storage class ocs-storagecluster-ceph-rbd when running on CoC PoT clusters
#mq00 reserved for instructor
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
export QMnamea="mq"$student"a"
export CONNAMEa="mq"$student"a-ibm-mq"
export SERVICEa="mq"$student"a-ibm-mq"
export CHANNELa="mq"$student"chla"
export TOCLUSa="TO_UNICLUS_mq"$student"a"
export QMnameb="mq"$student"b"
export CONNAMEb="mq"$student"b-ibm-mq"
export SERVICEb="mq"$student"b-ibm-mq"
export CHANNELb="mq"$student"chlb"
export TOCLUSb="TO_UNICLUS_mq"$student"b"
export QMnamec="mq"$student"c"
export CONNAMEc="mq"$student"c-ibm-mq"
export SERVICEc="mq"$student"c-ibm-mq"
export CHANNELc="mq"$student"chlc"
export TOCLUSc="TO_UNICLUS_mq"$student"c"
export UNICLUS=UNICLUS"$student"
export SC=ocs-storagecluster-ceph-rbd
#export SC=ibmc-file-gold-gid
export VERSION=9.3.0.0-r2

( echo "cat <<EOF" ; cat unicluster.yaml_template ; echo EOF ) | sh > unicluster.yaml

oc apply -f unicluster.yaml  -n $TARGET_NAMESPACE
