####
##    NOTE:  Make sure to logon to the recovery openshift cluster
####


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

# Get Recovery nhacrr route & host
oc login $OCP_CLUSTER2 -u integration-admin -p IntegrationWorkshop2025

export HOST=$(oc get route $TARGET_NAMESPACE-$QMGR_NAME-ibm-mq-nhacrr -o jsonpath='{.spec.host}')

( echo "cat <<EOF" ; cat 3-live-enable-crr-template.yaml ; echo EOF ) | sh > x-3-live-enable-crr.yaml

# Logon to the active cluster
oc login $OCP_CLUSTER1 -u integration-admin -p IntegrationWorkshop2025

oc patch QueueManager $TARGET_NAMESPACE-$QMGR_NAME --type merge --patch "$(cat nativeha-enable-crr.yaml)"
