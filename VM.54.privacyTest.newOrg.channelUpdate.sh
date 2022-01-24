MYHOME=$PWD
. env.sh
. scripts/configUpdate.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
HOST_ORG=${1}
NEW_ORG=${2}
#
. scripts/utils.sh
. scripts/VM.envVar.sh
#
export CHANNEL=channel.n2
#
setGlobals ${HOST_ORG}
#
peer channel update -f ${WRKDIR}/org${NEW_ORG}_update_in_envelope.pb -c ${CHANNEL} -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride ${ORDERER_HOSTNAME} --tls --cafile $ORDERER_CA
#
peer channel fetch 0 ${WRKDIR}/channel1.block -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride ${ORDERER_HOSTNAME} -c ${CHANNEL} --tls --cafile $ORDERER_CA
#
cd $PWD