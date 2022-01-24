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
export CHANNEL=channel.n1
# join channel
setGlobals ${HOST_ORG}
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
peer channel list
#
# Create channel
export CHANNEL=channel.n2
# join channel
setGlobals ${HOST_ORG}
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
peer channel list
#

cd $PWD