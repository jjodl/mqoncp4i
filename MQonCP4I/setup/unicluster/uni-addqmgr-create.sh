#! /bin/bash

#Use storage class ibmc-file-gold-gid when running on ROKS clusters
#Use storage class managed-nfs-storage when running on CoC PoT clusters
#mq"$2" reserved for instructor
#
#
export TARGET_NAMESPACE=$1
export QMpre="mq"$2

export CONNAMEa="mq"$2"a-ibm-mq"
export TOCLUSa="TO_UNICLUS_mq"$2"a"
export CONNAMEb="mq"$2"b-ibm-mq"
export TOCLUSb="TO_UNICLUS_mq"$2"b"
export CONNAMEc="mq"$2"c-ibm-mq"
export TOCLUSc="TO_UNICLUS_mq"$2"c"


export QMnamed="mq"$2"d"
export CONNAMEd="mq"$2"d-ibm-mq"
export SERVICEd="mq"$2"d-ibm-mq"
export CHANNELd="mq"$2"chld"
export TOCLUSd="TO_UNICLUS_mq"$2"d"
export UNICLUS=UNICLUS"$2"
export SC=ocs-storagecluster-ceph-rbd
#export SC=ibmc-file-gold-gid
export VERSION=9.3.0.0-r1
export UNICLUSTER_DIR="../unicluster/deploy/"

( echo 'cat <<EOF' ; cat unicluster/uni-addqmgr.sh_template ; echo EOF ) | sh > $UNICLUSTER_DIR"uni-addqmgr.sh"  
chmod +x $UNICLUSTER_DIR"uni-addqmgr.sh"
