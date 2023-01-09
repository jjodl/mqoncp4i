#! /bin/bash

#Use storage class ibmc-file-gold-gid when running on ROKS clusters
#Use storage class managed-nfs-storage when running on CoC PoT clusters
#mq"$2" reserved for instructor
#
#
export TARGET_NAMESPACE=$1
export QMpre="mq"$2
export QMname="mq"$2"strm"
export ROUTE="mq"$2"strmchl.chl.mq.ibm.com"
export CHLCAPS="mq"$2"STRMCHL"
export CHANNEL="mq"$2"strmchl"
export SC=ocs-storagecluster-ceph-rbd
#export SC=ibmc-file-gold-gid
export VERSION=9.3.0.0-r2
export STREAMQ_DIR="../streamq/deploy/"

( echo 'cat <<EOF' ; cat streamq/strm-install.sh_template ; echo EOF ) | sh > $STREAMQ_DIR"strm-install.sh"

chmod +x $STREAMQ_DIR"strm-install.sh"

