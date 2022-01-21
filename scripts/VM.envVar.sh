. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
export WRKDIR=./organizations/peerOrganizations/wrkdir


# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export ORDERER_HOSTNAME=orderer0.org1.example.com
    export ORDERER_ADDRESS=localhost:7050
    export ORDERER_CA=${PWD}/organizations/peerOrganizations/org1.example.com/orderers/orderer0.org1.example.com/tls/tlscacerts/tls-localhost-7054-ca-org1.pem
    export ORDERER_TLS_CERT=${PWD}/organizations/peerOrganizations/org1.example.com/orderers/orderer0.org1.example.com/tls/signcerts/cert.pem
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export ORDERER_HOSTNAME=orderer0.org2.example.com
    export ORDERER_ADDRESS=localhost:7050
    export ORDERER_CA=${PWD}/organizations/peerOrganizations/org2.example.com/orderers/orderer0.org2.example.com/tls/tlscacerts/tls-localhost-7054-ca-org2.pem
    export ORDERER_TLS_CERT=${PWD}/organizations/peerOrganizations/org2.example.com/orderers/orderer0.org2.example.com/tls/signcerts/cert.pem
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export ORDERER_HOSTNAME=orderer0.org3.example.com
    export ORDERER_ADDRESS=localhost:7050
    export ORDERER_CA=${PWD}/organizations/peerOrganizations/org3.example.com/orderers/orderer0.org3.example.com/tls/tlscacerts/tls-localhost-7054-ca-org3.pem
    #export ORDERER_TLS_CERT=${PWD}/organizations/peerOrganizations/org3.example.com/orderers/orderer0.org2.example.com/tls/signcerts/cert.pem
    #export ORDERER_HOSTNAME=orderer0.org2.example.com
    #export ORDERER_ADDRESS=localhost:7050
    #export ORDERER_CA=${PWD}/organizations/peerOrganizations/org2.example.com/orderers/orderer0.org2.example.com/tls/tlscacerts/tls-localhost-7054-ca-org2.pem
    export ORDERER_TLS_CERT=${PWD}/organizations/peerOrganizations/org3.example.com/orderers/orderer0.org3.example.com/tls/signcerts/cert.pem
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.org2.example.com:7051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.org3.example.com:7051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}