MYHOME=$PWD
. env.sh
. scripts/configUpdate.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/envVar.sh
#
export CHANNEL=channel.n2
#
setGlobals 1
#
fetchChannelConfig 1 ${CHANNEL} config_block.json

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org3MSP":.[1]}}}}}' ${WRKDIR}/config_block.json ${WRKDIR}/org3.json > ${WRKDIR}/modified_config_0.json
jq -s '.[0] * {"channel_group":{"groups":{"Orderer":{"groups": {"Org3MSP":.[1]}}}}}' ${WRKDIR}/modified_config_0.json ${WRKDIR}/org3Orderer.json > ${WRKDIR}/modified_config_1.json
jq '.channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters[.channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters| length] += input'  ${WRKDIR}/modified_config_1.json ${WRKDIR}/orderer0.org3.example.com.tlscert.json  > ${WRKDIR}/modified_config.json

createConfigUpdate ${CHANNEL} config_block.json modified_config.json org3_update_in_envelope.pb
#
signConfigtxAsPeerOrg 1 org3_update_in_envelope.pb
signConfigtxAsPeerOrg 2 org3_update_in_envelope.pb
#
setGlobals 1
peer channel update -f ${WRKDIR}/org3_update_in_envelope.pb -c ${CHANNEL} -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride ${ORDERER_HOSTNAME} --tls --cafile $ORDERER_CA
#
cd $PWD