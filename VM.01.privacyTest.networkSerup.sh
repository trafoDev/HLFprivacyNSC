MYHOME=$PWD
. env.sh
#cleaning the network from previous tests
HOST_ORG=${1}
#
./VM.99.clearNetwork.sh ${HOST_ORG}
#
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/VM.envVar.sh
#
mkdir -p organizations/peerOrganizations/fabric-ca/
cp -r ${PWD}/organizations/fabric-ca/* ${PWD}/organizations/peerOrganizations/fabric-ca
sed -i 's/organizations\/fabric-ca/organizations\/peerOrganizations\/fabric-ca/' ${PWD}/organizations/peerOrganizations/fabric-ca/registerEnroll.sh
#
echo "Ogr - " ${HOST_ORG}
echo "Please make sure there is docker swarm network defined, named as net_test"
pressAnyKey
#
docker-compose -f ./VMdocker/docker-compose-ca${HOST_ORG}.yaml -f ./VMdocker/docker-compose-network.yaml up -d
sleep 20
. organizations/peerOrganizations/fabric-ca/registerEnroll.sh
#
createOrg${HOST_ORG}
#
docker-compose -f ./VMdocker/docker-compose-couch${HOST_ORG}.yaml -f ./VMdocker/docker-compose-test-net${HOST_ORG}.yaml -f ./VMdocker/docker-compose-network.yaml up -d
sleep 20
docker-compose -f ./VMdocker/docker-compose-cli.yaml -f ./VMdocker/docker-compose-network.yaml up -d
sleep 10
echo "All network artifacts are created."
pressAnyKey

exit

mkdir -p organizations/peerOrganizations/wrkdir/
export CHANNEL=channel.n1
setGlobals 1
configtxgen -profile SampleAppChannelEtcdRaft -configPath ${PWD}/configtx -outputBlock organizations/peerOrganizations/wrkdir/${CHANNEL}.block -channelID ${CHANNEL}
# join channel
setGlobals 1
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
peer channel list
#
setGlobals 2
osnadmin channel list -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
osnadmin channel list -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
peer channel list
#
./network.sh deployCC -ccn private -ccp ../fabric-samples/chaincode/marbles02_private/go/ \
                      -ccl go -ccep "AND('Org1MSP.peer','Org2MSP.peer')" \
                      -cccg ../fabric-samples/chaincode/marbles02_private/collections_config.json -c ${CHANNEL}

# Create channel
export CHANNEL=channel.n2
setGlobals 1
configtxgen -profile SampleAppChannelEtcdRaft -configPath ${PWD}/configtx -outputBlock organizations/peerOrganizations/wrkdir/${CHANNEL}.block -channelID ${CHANNEL}
# join channel
setGlobals 1
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem
osnadmin channel list -o localhost:7080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
peer channel list
#
setGlobals 2
osnadmin channel list -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
osnadmin channel join --channelID ${CHANNEL} --config-block organizations/peerOrganizations/wrkdir/${CHANNEL}.block -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
osnadmin channel list -o localhost:9080 --ca-file $ORDERER_CA --client-cert ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem --client-key ./organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem
peer channel join -b organizations/peerOrganizations/wrkdir/${CHANNEL}.block
peer channel list
#
./network.sh deployCC -ccn marblesNoPDC -ccp ../fabric-samples/chaincode/marbles02/go/ \
                      -ccl go -ccep "AND('Org1MSP.peer','Org2MSP.peer')" \
                      -c ${CHANNEL} 

cd $PWD