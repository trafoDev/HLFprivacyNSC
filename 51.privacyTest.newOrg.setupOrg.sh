MYHOME=$PWD
. env.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/envVar.sh
#
docker-compose -f ./docker/docker-compose-ca3.yaml up -d
sleep 20
#
. organizations/peerOrganizations/fabric-ca/registerEnroll.sh
#
createOrg3
#
docker-compose -f ./docker/docker-compose-couch3.yaml -f ./docker/docker-compose-test-net3.yaml up -d
sleep 20
#
configtxgen -printOrg Org3MSP -configPath ./addOrg3 > ${WRKDIR}/org3.json
configtxgen -printOrg Org3MSP -configPath ./addOrg3Orderer > ${WRKDIR}/org3Orderer.json
#
setGlobals 3
ORDERER_CERT=$(base64 ${ORDERER_TLS_CERT} -w 0)
echo '{
    "client_tls_cert": "'${ORDERER_CERT}'",
    "host": "orderer0.org3.example.com",
    "port": 11050,
    "server_tls_cert": "'${ORDERER_CERT}'"
}' >${WRKDIR}/orderer0.org3.example.com.tlscert.json
#
echo "All network artifacts for a new organization are created."

cd $PWD