MYHOME=$PWD
. env.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
HOST_ORG=${1}
#
. scripts/utils.sh
. scripts/VM.envVar.sh
#
mkdir -p organizations/peerOrganizations/wrkdir/
#
echo 'Organizations:
    - &Org'${HOST_ORG}'
        Name: Org'${HOST_ORG}'MSP
        ID: Org'${HOST_ORG}'MSP
        MSPDir: ../org'${HOST_ORG}'.example.com/msp
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.member'\'')"
            Writers:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.member'\'')"
            Admins:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.admin'\'')"
            Endorsement:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.peer'\'')"
' >${WRKDIR}/configtx.yaml
configtxgen -printOrg Org${HOST_ORG}MSP -configPath ${WRKDIR} > ${WRKDIR}/org${HOST_ORG}.json
#
echo 'Organizations:
    - &Org'${HOST_ORG}'
        Name: Org'${HOST_ORG}'MSP
        ID: Org'${HOST_ORG}'MSP
        MSPDir: ../org'${HOST_ORG}'.example.com/msp
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.member'\'')"
            Writers:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.member'\'')"
            Admins:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.admin'\'')"
            Endorsement:
                Type: Signature
                Rule: "OR('\''Org'${HOST_ORG}'MSP.peer'\'')"
        OrdererEndpoints:
            - orderer0.org'${HOST_ORG}'.example.com:7050
' >${WRKDIR}/configtx.yaml
configtxgen -printOrg Org${HOST_ORG}MSP -configPath ${WRKDIR} > ${WRKDIR}/org${HOST_ORG}Orderer.json
#
setGlobals 3
ORDERER_CERT=$(base64 ${ORDERER_TLS_CERT} -w 0)
echo '{
    "client_tls_cert": "'${ORDERER_CERT}'",
    "host": "orderer0.org'${HOST_ORG}'.example.com",
    "port": 7050,
    "server_tls_cert": "'${ORDERER_CERT}'"
}' >${WRKDIR}/orderer0.org${HOST_ORG}.example.com.tlscert.json
#
echo "All network artifacts for a new organization are created."

cd $PWD