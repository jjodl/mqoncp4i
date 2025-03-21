#! /bin/bash
#
#Use storage class ocs-storagecluster-ceph-rbd when running on CoC PoT clusters
#mq00 reserved for instructor
#
# Set script variables
#
source setup.properties
textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
green=$(tput setaf 2) 
yellow=$(tput setaf 3) 
bold=$(tput bold)
normal=$(tput sgr0)
#
# This script will create the required build scripts for all MQ labs 
#
ERRORMSG1="Error invalid arg:  \n\n
Usage: $0 -i 01 -n student1 -p Primary host -r Recovery host\n
    -i, Student number \n
    -n, Student Namespace \n
    -p, Host name for primary cluster \n
    -r, Host name for recovery cluster \n"

ERRORMSG2="Missing args:  \n\n
Usage: $0 -i 01 -n student1 -p Primary host -r Recovery host\n
    -i, Student number \n
    -n, Student Namespace \n
    -p, Host name for primary cluster \n
    -r, Host name for recovery cluster \n"

   while getopts ':i:n:p:r:' flag;
     do
       case "${flag}" in
         i) student=${OPTARG}
                printf -v STUDENT_NUM "%02d" $student; 
           	echo $STUDENT_NUM
	      ;;
         n) NS=${OPTARG}
        ;;
         p) PRI_HOST=${OPTARG}
        ;;
         r) RECV_HOST=${OPTARG}
         ;;
         *) echo -e ${ERRORMSG1}
		exit 1;;
       esac
   done
if [ $OPTIND -ne 9 ]; then
   echo -e ${ERRORMSG2} 
   exit 1
fi
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
# make sure you pass valid args for the hosts names 
#
echo ""
echo " ${bold}Host example format: https://api.67c202f1d1ee7bb0b5bead95.am1.techzone.ibm.com:6443${textreset}"
echo ""
echo " You have set the Primary Host for nativeHA to ${bold}$PRI_HOST${textreset}"
echo " and "
echo " The Recovery Host for CCR to ${bold}$RECV_HOST${textreset}"	 
echo ""
 while true; do
   read -p "${bold}Are these correct?  (Y/N)${textreset}" yn
   case $yn in
       [Yy]* ) break;;
       [Nn]* ) exit 1;;
       * ) echo "Please answer y or n.";;
   esac
 done

##oc login https://api.67c202f1d1ee7bb0b5bead95.am1.techzone.ibm.com:6443 -u student2 -p welcometoFSMpot
###oc project $TARGET_NAMESPACE

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
   export QMGR_NS="-"$TARGET_NAMESPACE
fi
export QMpre="mq"$STUDENT_NUM
export VERSION=$IBM_MQ_VERSION
export LICENSE=$IBM_MQ_LICENSE
export MQ_NATIVEHA_HOST=$PRI_HOST
export MQ_RECOVERY_HOST=$RECV_HOST
export SC=ocs-storagecluster-ceph-rbd
#export SC=ibmc-file-gold-gid
#
# Build the StreamQ build yaml script.
#
echo "..."
echo "[INFO] Build the ${bold}deployment yamls and test scripts for streamQ labs. ${normal} "

export QMInstance=$QMGR_NS$QMpre"strm"
export QMname="mq"$STUDENT_NUM"strm"
export ROUTE="mq"$STUDENT_NUM"strmchl.chl.mq.ibm.com"
export CHLCAPS="MQ"$STUDENT_NUM"STRMCHL"
export CHANNEL="mq"$STUDENT_NUM"strmchl"
export STREAMQ_DIR="streamq/deploy/"

( echo 'cat <<EOF' ; cat template/strm-install.sh_template ; echo EOF ) | sh > $STREAMQ_DIR"strm-install.sh"

chmod +x $STREAMQ_DIR"strm-install.sh"

echo "[INFO] StreamQ build yaml script is complete."
#
# Build the nativeHA build yaml script.
#
echo "...."
echo "[INFO] Build the ${bold}deployment yamls and test scripts for navtiveHA labs. ${normal} "

export QMname="mq"$STUDENT_NUM"ha"
export QMInstance=$$QMGR_NS$QMname
export CHANNEL="mq"$STUDENT_NUM"hachl"
export CHLCAPS="MQ"$STUDENT_NUM"HACHL"
export HA_DIR="nativeha/deploy/"

( echo 'cat <<EOF' ; cat template/nativeha-install.sh_template ; echo EOF ) | sh > $HA_DIR"ha-install.sh"

chmod +x $HA_DIR"ha-install.sh"

echo "[INFO] nativeHA build yaml script is complete."
#
# Build the nativeHA CRR build yaml script.
#
echo "...."
echo "[INFO] Build the ${bold}deployment yamls and test scripts for navtiveHA CRR labs. ${normal} "

export QMname="mq"$STUDENT_NUM"ha"
export QMInstance=$QMGR_NS$QMname
export CHANNEL="mq"$STUDENT_NUM"hachl"
export CHLCAPS="MQ"$STUDENT_NUM"HACHL"
export HA_DIR="nativeha/deploy/"

( echo 'cat <<EOF' ; cat template/nativeha-crr-install.sh_template ; echo EOF ) | sh > $HA_DIR"2-ha-crr-install.sh"

chmod +x $HA_DIR"ha-crr-install.sh"

echo "[INFO] nativeHA CRR build yaml script is complete."
#
# Build the UniCluster build yaml scripts.
#
echo "...."
echo "[INFO] Build the ${bold}deployment yamls and test scripts for unicluster labs. ${normal} "

export QMInstancea=$QMGR_NS"mq"$STUDENT_NUM"a"
export QMnamea="mq"$STUDENT_NUM"a"
export CONNAMEa=$NS"-mq"$STUDENT_NUM"a-ibm-mq"
export SERVICEa="mq"$STUDENT_NUM"a-ibm-mq"
export CHANNELa="mq"$STUDENT_NUM"chla"
export TOCLUSa="TO_UNICLUS_mq"$STUDENT_NUM"a"

export QMInstanceb=$QMGR_NS"mq"$STUDENT_NUM"b"
export QMnameb="mq"$STUDENT_NUM"b"
export CONNAMEb=$NS"-mq"$STUDENT_NUM"b-ibm-mq"
export SERVICEb="mq"$STUDENT_NUM"b-ibm-mq"
export CHANNELb="mq"$STUDENT_NUM"chlb"
export TOCLUSb="TO_UNICLUS_mq"$STUDENT_NUM"b"

export QMInstancec=$QMGR_NS"mq"$STUDENT_NUM"c"
export QMnamec="mq"$STUDENT_NUM"c"
export CONNAMEc=$NS"-mq"$STUDENT_NUM"c-ibm-mq"
export SERVICEc="mq"$STUDENT_NUM"c-ibm-mq"
export CHANNELc="mq"$STUDENT_NUM"chlc"
export TOCLUSc="TO_UNICLUS_mq"$STUDENT_NUM"c"

export UNICLUS=UNICLUS"$STUDENT_NUM"

export UNICLUSTER_DIR="unicluster/deploy/"
( echo 'cat <<EOF' ; cat template/uni-install.sh_template ; echo EOF ) | sh > $UNICLUSTER_DIR"uni-install.sh" 
chmod +x $UNICLUSTER_DIR"uni-install.sh"

echo "[INFO] unicluster build yaml scripts is complete."




