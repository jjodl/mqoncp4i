#! /bin/bash

#Use storage class ibmc-file-gold-gid when running on ROKS clusters
#Use storage class managed-nfs-storage when running on CoC PoT clusters
#mq"$2" reserved for instructor
#
#
export TARGET_NAMESPACE=$1
export QMpre="mq"$2
export QMInstancea=$TARGET_NAMESPACE"-mq"$2"a"
export QMnamea="mq"$2"a"
export CONNAMEa=$1"-mq"$2"a-ibm-mq"
export SERVICEa="mq"$2"a-ibm-mq"
export CHANNELa="mq"$2"chla"
export TOCLUSa="TO_UNICLUS_mq"$2"a"
export QMInstanceb=$TARGET_NAMESPACE"-mq"$2"b"
export QMnameb="mq"$2"b"
export CONNAMEb=$1"-mq"$2"b-ibm-mq"
export SERVICEb="mq"$2"b-ibm-mq"
export CHANNELb="mq"$2"chlb"
export TOCLUSb="TO_UNICLUS_mq"$2"b"
export QMInstancec=$TARGET_NAMESPACE"-mq"$2"c"
export QMnamec="mq"$2"c"
export CONNAMEc=$1"-mq"$2"c-ibm-mq"
export SERVICEc="mq"$2"c-ibm-mq"
export CHANNELc="mq"$2"chlc"
export TOCLUSc="TO_UNICLUS_mq"$2"c"
export UNICLUS=UNICLUS"$2"
export SC=ocs-storagecluster-ceph-rbd
#export SC=ibmc-file-gold-gid
export VERSION=9.3.5.0-r1
export UNICLUSTER_DIR="../unicluster/deploy/"
( echo 'cat <<EOF' ; cat unicluster/uni-install.sh_template ; echo EOF ) | sh > $UNICLUSTER_DIR"uni-install.sh" 
##( echo 'cat <<EOF' ; cat uni-install.sh_template ; echo EOF ) | sh > unicluster/deploy/uni-install.sh 
chmod +x $UNICLUSTER_DIR"uni-install.sh"

