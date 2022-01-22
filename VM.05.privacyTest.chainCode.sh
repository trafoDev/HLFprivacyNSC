MYHOME=$PWD
. VM.env.sh

#initialize marble without PDC
export HOST_ORG=${1}

setEnv4Org ${HOST_ORG}
echo "Create marble1 object using marblesNoPDC chaincode installed on channel.n2 channel"
peer chaincode invoke -o orderer0.org${HOST_ORG}.example.com:7050 --ordererTLSHostnameOverride orderer0.org${HOST_ORG}.example.com \
                      --tls --cafile ${ORDERER_CA} \
	                  --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
	                  --peerAddresses peer0.org2.example.com:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
                      -C channel.n2 -n marblesNoPDC -c '{"Args":["initMarble","marble1","blue","135","jerry"]}'

#wait 2 second for block to be created 
sleep 2
echo "Marble >>marble1<< has been created"
pressAnyKey

echo "Querying org1 ledger about marble1" 
setEnv4Org ${HOST_ORG}
peer chaincode query -C channel.n2 -n marblesNoPDC -c '{"Args":["readMarble","marble1"]}'
#

cd $PWD

