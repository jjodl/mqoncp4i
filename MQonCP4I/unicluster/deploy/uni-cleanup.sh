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
#mq00 reserved for instructor
#
export TARGET_NAMESPACE=$namespace
export QMpre="mq"$student 
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
export QMnamed="mq"$student"d"
export CONNAMEd="mq"$student"d-ibm-mq"
export SERVICEd="mq"$student"d-ibm-mq"
export CHANNELd="mq"$student"chld"
export TOCLUSd="TO_UNICLUS_mq"$student"d"
export UNICLUS=UNICLUS"$student"
#
oc delete secret $QMpre-uniform-cluster-cert -n $TARGET_NAMESPACE
oc delete queuemanager $QMnamea -n $TARGET_NAMESPACE
oc delete route mq-traffic-mq-$QMnamea-ibm-mq-qm -n $TARGET_NAMESPACE
oc delete configmap $QMnamea-uniform-cluster-mqsc-1 -n $TARGET_NAMESPACE
oc delete configmap $QMnamea-uniform-cluster-ini-1 -n $TARGET_NAMESPACE
oc delete pvc data-$QMnamea-ibm-mq-0 -n $TARGET_NAMESPACE
oc delete pvc $QMnamea-ibm-mq-persisted-data -n $TARGET_NAMESPACE
oc delete pvc $QMnamea-ibm-mq-recovery-logs -n $TARGET_NAMESPACE
oc delete queuemanager $QMnameb -n $TARGET_NAMESPACE
oc delete route mq-traffic-mq-$QMnameb-ibm-mq-qm -n $TARGET_NAMESPACE
oc delete configmap $QMnameb-uniform-cluster-mqsc-2 -n $TARGET_NAMESPACE
oc delete configmap $QMnameb-uniform-cluster-ini-2 -n $TARGET_NAMESPACE
oc delete pvc data-$QMnameb-ibm-mq-0 -n $TARGET_NAMESPACE
oc delete pvc $QMnameb-ibm-mq-persisted-data -n $TARGET_NAMESPACE
oc delete pvc $QMnameb-ibm-mq-recovery-logs -n $TARGET_NAMESPACE
oc delete queuemanager $QMnamec -n $TARGET_NAMESPACE
oc delete route mq-traffic-mq-$QMnamec-ibm-mq-qm -n $TARGET_NAMESPACE
oc delete configmap $QMnamec-uniform-cluster-mqsc-3 -n $TARGET_NAMESPACE
oc delete configmap $QMnamec-uniform-cluster-ini-3 -n $TARGET_NAMESPACE
oc delete pvc data-$QMnamec-ibm-mq-0 -n $TARGET_NAMESPACE
oc delete pvc $QMnamec-ibm-mq-persisted-data -n $TARGET_NAMESPACE
oc delete pvc $QMnamec-ibm-mq-recovery-logs -n $TARGET_NAMESPACE
oc delete queuemanager $QMnamed -n $TARGET_NAMESPACE
oc delete route mq-traffic-mq-$QMnamed-ibm-mq-qm -n $TARGET_NAMESPACE
oc delete configmap $QMnamed-uniform-cluster-mqsc-4 -n $TARGET_NAMESPACE
oc delete configmap $QMnamed-uniform-cluster-ini-4 -n $TARGET_NAMESPACE
oc delete pvc data-$QMnamed-ibm-mq-0 -n $TARGET_NAMESPACE
oc delete pvc $QMnamed-ibm-mq-persisted-data -n $TARGET_NAMESPACE
oc delete pvc $QMnamed-ibm-mq-recovery-logs -n $TARGET_NAMESPACE
rm unicluster.yaml
rm uniaddqmgr.yaml
rm uni-addqmgr.sh
rm uni-install.sh
