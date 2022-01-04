MYHOME=$PWD
. env.sh

cleaning the network from previous tests
./99.clearNetwork.sh
#
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/envVar.sh
#
mkdir -p organizations/peerOrganizations/fabric-ca/
cp -r ${PWD}/organizations/fabric-ca/* ${PWD}/organizations/peerOrganizations/fabric-ca
sed -i 's/organizations\/fabric-ca/organizations\/peerOrganizations\/fabric-ca/' ${PWD}/organizations/peerOrganizations/fabric-ca/registerEnroll.sh
#
docker-compose -f ./docker/docker-compose-ca.yaml up -d
sleep 20
. organizations/peerOrganizations/fabric-ca/registerEnroll.sh
#
createOrg1
createOrg2
#
docker-compose -f ./docker/docker-compose-couch.yaml -f ./docker/docker-compose-test-net.yaml up -d
sleep 20
echo "All network artifacts are created."
pressAnyKey


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


#cd
#cd fabric-samples/test-network
#cleaning the network from previous tests
#./network.sh down
#cd addOrg3
#./addOrg3.sh down
#cd .. 
#create a simple network (two orgs) with marbles chaincode with PCD enabled
#./network.sh up createChannel -ca -s couchdb -c channel.n1
#./network.sh deployCC -ccn private -ccp ../chaincode/marbles02_private/go/ \
#                      -ccl go -ccep "AND('Org1MSP.peer','Org2MSP.peer')" \
#                      -cccg ../chaincode/marbles02_private/collections_config.json -c channel.n1
#create a simple network (two orgs) with marbles chaincode - no PCD
#exit
#./network.sh createChannel -c channel.n2
./network.sh deployCC -ccn private -ccp ../fabric-samples/chaincode/marbles02/go/ \
                      -ccl go -ccep "AND('Org1MSP.peer','Org2MSP.peer')" \
                      -c ${CHANNEL} -ccn marblesNoPDC

cd $PWD