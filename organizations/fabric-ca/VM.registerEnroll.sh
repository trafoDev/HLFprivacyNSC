#!/bin/bash

function createOrg() {
  HOST_ORG=${1}

  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org${HOST_ORG}.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org${HOST_ORG} --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org'${HOST_ORG}'.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org'${HOST_ORG}'.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org'${HOST_ORG}'.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org'${HOST_ORG}'.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org${HOST_ORG} --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer0"
  set -x
  fabric-ca-client register --caname ca-org${HOST_ORG} --id.name orderer0 --id.secret orderer0pw --id.type orderer --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org${HOST_ORG} --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org${HOST_ORG} --id.name org${HOST_ORG}admin --id.secret org${HOST_ORG}adminpw --id.type admin --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org${HOST_ORG} -M ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/msp --csr.hosts peer0.org${HOST_ORG}.example.com --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/msp/config.yaml

  infoln "Generating the orderer0 msp"
  set -x
  fabric-ca-client enroll -u https://orderer0:orderer0pw@localhost:7054 --caname ca-org${HOST_ORG} -M ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/msp --csr.hosts orderer0.org${HOST_ORG}.example.com --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org${HOST_ORG} -M ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls --enrollment.profile tls --csr.hosts peer0.org${HOST_ORG}.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/tlsca/tlsca.org${HOST_ORG}.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/peers/peer0.org${HOST_ORG}.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/ca/ca.org${HOST_ORG}.example.com-cert.pem

  infoln "Generating the orderer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer0:orderer0pw@localhost:7054 --caname ca-org${HOST_ORG} -M ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls --enrollment.profile tls --csr.hosts orderer0.org${HOST_ORG}.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/tlsca/tlsca.org${HOST_ORG}.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/orderers/orderer0.org${HOST_ORG}.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/ca/ca.org${HOST_ORG}.example.com-cert.pem

  infoln "Generating the user msp" 
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org${HOST_ORG} -M ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/User1@org${HOST_ORG}.example.com/msp --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/User1@org${HOST_ORG}.example.com/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/User1@org${HOST_ORG}.example.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/User1@org${HOST_ORG}.example.com/msp/keystore/key.pem

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org${HOST_ORG}admin:org${HOST_ORG}adminpw@localhost:7054 --caname ca-org${HOST_ORG} -M ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp --tls.certfiles ${PWD}/organizations/peerOrganizations/fabric-ca/org${HOST_ORG}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org${HOST_ORG}.example.com/users/Admin@org${HOST_ORG}.example.com/msp/keystore/key.pem

}
