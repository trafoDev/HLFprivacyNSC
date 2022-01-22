
set -o allexport; source .env; set +o allexport

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/

function echoEnv() {
# Environment variables for Org1
  echo $CORE_PEER_TLS_ENABLED
  echo $CORE_PEER_LOCALMSPID
  echo $CORE_PEER_TLS_ROOTCERT_FILE
  echo $CORE_PEER_MSPCONFIGPATH
  echo $CORE_PEER_ADDRESS
}

function clearEnv() {
# Environment variables for Org1
  export CORE_PEER_TLS_ENABLED=
  export CORE_PEER_LOCALMSPID=
  export CORE_PEER_TLS_ROOTCERT_FILE=
  export CORE_PEER_MSPCONFIGPATH=
  export CORE_PEER_ADDRESS=
}

function setEnv4Org() {
# Environment variables for Org1
  local ORG=$1
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_LOCALMSPID="Org"${ORG}"MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org${ORG}.example.com/peers/peer0.org${ORG}.example.com/tls/ca.crt
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org${ORG}.example.com/users/Admin@org${ORG}.example.com/msp
  export CORE_PEER_ADDRESS=peer0.org${ORG}.example.com:7051
  export PEER_ID=peer0.org${ORG}.example.com
  export ORDERER_CA=${PWD}/organizations/peerOrganizations/org${ORG}.example.com/orderers/orderer0.org${ORG}.example.com/tls/tlscacerts/tls-localhost-7054-ca-org${ORG}.pem
}

function pressAnyKey() {
  echo -e "Press any key to continue...\n"; read -n1 -s -r -p "" key
}
###################################################################################################
