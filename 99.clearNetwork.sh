MYHOME=$PWD
. env.sh

#clearing data from the second part of testing scenario
#./19.privacyTestPart2.clearNetwork.sh
#clearing data from the third part of testing scenario
#./39.privacyTestPart3.clearNetwork.sh

#clearing data from the org3 test
./59.clearNetwork.newOrg.clear.sh

#clearing the network
. scripts/utils.sh

docker-compose -f ./docker/docker-compose-couch1.yaml -f ./docker/docker-compose-test-net1.yaml  -f ./docker/docker-compose-network.yaml down
docker-compose -f ./docker/docker-compose-couch2.yaml -f ./docker/docker-compose-test-net2.yaml  -f ./docker/docker-compose-network.yaml down
docker-compose -f ./docker/docker-compose-ca1.yaml  -f ./docker/docker-compose-network.yaml down
docker-compose -f ./docker/docker-compose-ca2.yaml  -f ./docker/docker-compose-network.yaml down
docker-compose -f ./docker/docker-compose-cli.yaml  -f ./docker/docker-compose-network.yaml down
#
docker network rm net_test
#
docker volume rm ${COMPOSE_PROJECT_NAME}_orderer0.org1.example.com
docker volume rm ${COMPOSE_PROJECT_NAME}_orderer0.org2.example.com
docker volume rm ${COMPOSE_PROJECT_NAME}_peer0.org2.example.com
docker volume rm ${COMPOSE_PROJECT_NAME}_peer0.org1.example.com
#
sudo rm -Rf ./organizations/peerOrganizations
rm log.txt
rm *.tar.gz


#cleaning the Blockchain Explorer
#cd $MYHOME/explorer
#./clean_explorer.sh

cd $PWD