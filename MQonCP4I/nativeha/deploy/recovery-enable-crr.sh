####
##    NOTE:  Make sure to logon to the recovery openshift cluster
####
#
# This script will create the required build scripts for all MQ labs 
#
source nativeha.properties
ERRORMSG1="Error invalid arg:  \n
Usage: $0 -p xxxxxxx \n"

ERRORMSG2="Missing args:  \n
Usage: $0 -p xxxxxxx \n
    -p, password \n"
   while getopts ':p:' flag;
     do
       case "${flag}" in
         p) PASSWORD=${OPTARG}
        ;;
         *) echo -e ${ERRORMSG1}
		exit 1;;
       esac
   done
if [ $OPTIND -ne 3 ]; then
   echo -e ${ERRORMSG2} 
   exit 1
fi
echo "URL1 = " $OCP_CLUSTER1
echo "URL2 = " $OCP_CLUSTER2
echo "QMGR = " $QMGR
echo "NS = " $NS
echo "Userid =" $USERID
exit
#
# make sure you pass valid args
#
echo " You have set the Namespace to $NS and the instance number to $STUDENT_NUM"	 
 while true; do
   read -p "${bold}Are these correct?  The instance number is zero filled for numbers 1-9. (Y/N)${textreset}" yn
   case $yn in
       [Yy]* ) break;;
       [Nn]* ) exit 1;;
       * ) echo "Please answer y or n.";;
   esac
 done
#
# Set all common variables
#
export IBM_MQ_LICENSE=$IBM_MQ_LICENSE
export IBM_MQ_VERSION=$IBM_MQ_VERSION
export TARGET_NAMESPACE=$NS
if [ $NS == "cp4i-mq" ]
  then
   export QMGR_NS=""
   else 
   export QMGR_NS=$TARGET_NAMESPACE"-"
fi
echo "QMGR_NS = " $QMGR_NS
export QMpre="mq"$STUDENT_NUM



export QMGR_NAME=$1
export TARGET_NAMESPACE=$2

if [[ -z "${QMGR_NAME// /}" ]]; then
  echo -e "Syntax error: $0 <qmgr-name> <namespace>. Example $0 mq02ha student2"
  exit 1
fi

if [[ -z "${TARGET_NAMESPACE// /}" ]]; then
  echo -e "Syntax error: $0 <qmgr-name> <namespace>. Example $0 mq02ha student2"
  exit 1
fi

export URL=$OCP_CLUSTER1
# Get active nhacrr route & host
oc login https://api.67c20883d1ee7bb0b5beada0.am1.techzone.ibm.com:6443 -u student2 -p welcometoFSMpot

export HOST=$(oc get route $TARGET_NAMESPACE-$QMGR_NAME-ibm-mq-nhacrr -o jsonpath='{.spec.host}')

( echo "cat <<EOF" ; cat 4-recovery-enable-crr-template.yaml ; echo EOF ) | sh > x-4-recovery-enable-crr.yaml

# Logon to the recovery cluster
oc login https://api.67c202f1d1ee7bb0b5bead95.am1.techzone.ibm.com:6443 -u student2 -p welcometoFSMpot

oc patch QueueManager $TARGET_NAMESPACE-$QMGR_NAME --type merge --patch "$(cat x-4-recovery-enable-crr.yaml)"
