MYHOME=$PWD
. env.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/envVar.sh
#
export CHANNEL=channel.n3
setGlobals 3
configtxgen -profile NewAppChannelEtcdRaft -configPath addNewChannel -outputBlock organizations/peerOrganizations/wrkdir/${CHANNEL}.block -channelID ${CHANNEL}
# join channel
setGlobals 3
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:11080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
#
setGlobals 2
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
#
echo "Channels - Org1"
setGlobals 1
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem
peer channel list
#
echo "Channels - Org2"
setGlobals 2
osnadmin channel list -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
peer channel list
#
echo "Channels - Org3"
setGlobals 3
osnadmin channel list -o localhost:11080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/key.pem
peer channel list

cd $PWD