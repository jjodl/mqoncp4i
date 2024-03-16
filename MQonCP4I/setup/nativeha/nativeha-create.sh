#! /bin/bash

#Use storage class ibmc-file-gold-gid when running on ROKS clusters
#Use storage class managed-nfs-storage when running on CoC PoT clusters
#mq"$2" reserved for instructor
#
#
export TARGET_NAMESPACE=$1
export QMpre="mq"$2
####export QMname="mq"$2"ha"
export QMInstance=$TARGET_NAMESPACE"-qm-ha"
export QMname="mq"$2"-qm-ha"
export CHANNEL="mq"$2"hachl"
export CHLCAPS="MQ"$2"HACHL"
export VERSION=9.3.5.0-r1
export SC=ocs-storagecluster-ceph-rbd
#export SC=ibmc-file-gold-gid
export HA_DIR="../nativeha/deploy/"

( echo 'cat <<EOF' ; cat nativeha/nativeha-install.sh_template ; echo EOF ) | sh > $HA_DIR"ha-install.sh"

chmod +x $HA_DIR"ha-install.sh"
