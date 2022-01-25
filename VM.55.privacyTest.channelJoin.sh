MYHOME=$PWD
. VM.env.sh
#cleaning the network from previous tests
HOST_ORG=${1}
#
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/VM.envVar.sh
#
export CHANNEL=channel.n2
# join channel
setGlobals ${HOST_ORG}
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/channel1.block -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/channel1.block
#
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
peer channel list
#
echo 'Wait for orderer and peer to communicate with the network channel'
sleep 60
#
./scripts/VM.setAnchorPeer.sh 3 ${CHANNEL}
#


cd $PWD