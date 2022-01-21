MYHOME=$PWD
. env.sh

#clearing data from the org3 test
#./59.clearNetwork.newOrg.clear.sh

#clearing the network
. scripts/utils.sh

HOST_ORG=${1}

docker-compose -f ./VMdocker/docker-compose-couch${HOST_ORG}.yaml -f ./VMdocker/docker-compose-test-net${HOST_ORG}.yaml  -f ./VMdocker/docker-compose-network.yaml down
docker-compose -f ./VMdocker/docker-compose-ca${HOST_ORG}.yaml  -f ./VMdocker/docker-compose-network.yaml down
docker-compose -f ./VMdocker/docker-compose-cli.yaml  -f ./VMdocker/docker-compose-network.yaml down
#
docker network rm net_test
#
docker volume rm ${COMPOSE_PROJECT_NAME}_orderer0.org${HOST_ORG}.example.com
docker volume rm ${COMPOSE_PROJECT_NAME}_peer0.org${HOST_ORG}.example.com
#
sudo rm -Rf ./organizations/peerOrganizations
rm log.txt
rm *.tar.gz


#cleaning the Blockchain Explorer
#cd $MYHOME/explorer
#./clean_explorer.sh

cd $PWD