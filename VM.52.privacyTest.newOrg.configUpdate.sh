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
fetchChannelConfig ${HOST_ORG} ${CHANNEL} config_block.json

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org'${NEW_ORG}'MSP":.[1]}}}}}' ${WRKDIR}/config_block.json ${WRKDIR}/org${NEW_ORG}.json > ${WRKDIR}/modified_config_0.json
jq -s '.[0] * {"channel_group":{"groups":{"Orderer":{"groups": {"Org'${NEW_ORG}'MSP":.[1]}}}}}' ${WRKDIR}/modified_config_0.json ${WRKDIR}/org${NEW_ORG}Orderer.json > ${WRKDIR}/modified_config_1.json
jq '.channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters[.channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters| length] += input'  ${WRKDIR}/modified_config_1.json ${WRKDIR}/orderer0.org${NEW_ORG}.example.com.tlscert.json  > ${WRKDIR}/modified_config.json

createConfigUpdate ${CHANNEL} config_block.json modified_config.json org${NEW_ORG}_update_in_envelope.pb
#
cd $PWD