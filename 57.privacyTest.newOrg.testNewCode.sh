MYHOME=$PWD
. env.sh

#initialize marble without PDC
setEnv4Org3
echo "Create marble1 object using marblesNoPDC3 chaincode installed on channel.n3 channel"
peer chaincode invoke -o localhost:11050 --ordererTLSHostnameOverride orderer0.org3.example.com \
                      --tls --cafile ${ORDERER_CA} \
	                  --peerAddresses localhost:11051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
	                  --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
                      -C channel.n3 -n marblesNoPDC3 -c '{"Args":["initMarble","marble1","blue","135","jerry"]}'

#wait 2 second for block to be created
sleep 2
echo "Marble >>marble1<< has been created"
pressAnyKey

echo "Querying org3 ledger about marble1" 
setEnv4Org3
peer chaincode query -C channel.n3 -n marblesNoPDC3 -c '{"Args":["readMarble","marble1"]}'
#
echo "Querying org2 ledger about marble1" 
setEnv4Org2
peer chaincode query -C channel.n3 -n marblesNoPDC3 -c '{"Args":["readMarble","marble1"]}'
pressAnyKey

setEnv4Org3
echo "Create marble1 once more object using marblesNoPDC3 chaincode installed on channel.n3 channel"
peer chaincode invoke -o localhost:11050 --ordererTLSHostnameOverride orderer0.org3.example.com \
                      --tls --cafile ${ORDERER_CA} \
	                  --peerAddresses localhost:11051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
	                  --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
                      -C channel.n3 -n marblesNoPDC3 -c '{"Args":["initMarble","marble1","blue","135","jerry"]}'

#wait 2 second for block to be created
sleep 2

cd $PWD

