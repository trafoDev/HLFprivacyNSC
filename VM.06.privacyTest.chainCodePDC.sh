MYHOME=$PWD
. VM.env.sh

#initialize marble with data stored in PDC
export HOST_ORG=${1}

setEnv4Org ${HOST_ORG}
export MARBLE=$(echo -n "{\"name\":\"marble1\",\"color\":\"blue\",\"size\":35,\"owner\":\"tom\",\"price\":99}" | base64 | tr -d \\n)
peer chaincode invoke -o orderer0.org${HOST_ORG}.example.com:7050 --ordererTLSHostnameOverride orderer0.org${HOST_ORG}.example.com \
                      --tls --cafile ${ORDERER_CA} \
	                  --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
	                  --peerAddresses peer0.org2.example.com:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
                      -C channel.n1 -n private -c '{"Args":["InitMarble"]}' --transient "{\"marble\":\"$MARBLE\"}" 

#wait 2 second for block to be created
sleep 2
echo "Marble >>marble1<< has been created using chaincode with PDC"
pressAnyKey

echo "Querying org1 ledger about marble1 - chaincode with PDC" 
setEnv4Org ${HOST_ORG}
peer chaincode query -C channel.n1 -n private -c '{"Args":["ReadMarble","marble1"]}'
peer chaincode query -C channel.n1 -n private -c '{"Args":["ReadMarblePrivateDetails","marble1"]}'
#

cd $PWD



