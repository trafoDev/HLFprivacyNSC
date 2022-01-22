MYHOME=$PWD
. env.sh
#cleaning the network from previous tests
HOST_ORG=${1}
#
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/VM.envVar.sh
#
mkdir -p organizations/peerOrganizations/wrkdir/
export CHANNEL=channel.n1
setGlobals 1
configtxgen -profile SampleAppChannelEtcdRaft -configPath ${PWD}/VMconfigtx -outputBlock organizations/peerOrganizations/wrkdir/${CHANNEL}.block -channelID ${CHANNEL}

# Create channel
export CHANNEL=channel.n2
setGlobals 1
configtxgen -profile SampleAppChannelEtcdRaft -configPath ${PWD}/VMconfigtx -outputBlock organizations/peerOrganizations/wrkdir/${CHANNEL}.block -channelID ${CHANNEL}

cd $PWD