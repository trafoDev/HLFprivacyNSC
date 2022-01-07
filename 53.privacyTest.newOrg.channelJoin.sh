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
setGlobals 2
##exit
peer channel fetch 0 ./organizations/peerOrganizations/wrkdir/channel1.block -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride ${ORDERER_HOSTNAME} -c ${CHANNEL} --tls --cafile $ORDERER_CA
sleep 2
#
setGlobals 3
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/channel1.block -o localhost:11080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/key.pem
sleep 2
#
peer channel join -b ./organizations/peerOrganizations/wrkdir/channel1.block
sleep 2
#
setGlobals 3
./scripts/setAnchorPeer.sh 3 ${CHANNEL}

cd $PWD