MYHOME=$PWD
. env.sh

#clearing data from the second part of testing scenario
#./19.privacyTestPart2.clearNetwork.sh
#clearing data from the third part of testing scenario
#./39.privacyTestPart3.clearNetwork.sh

#clearing the network
. scripts/utils.sh

docker-compose -f ./docker/docker-compose-couch3.yaml -f ./docker/docker-compose-test-net3.yaml down
docker-compose -f ./docker/docker-compose-ca3.yaml down
#
docker volume rm ${COMPOSE_PROJECT_NAME}_orderer0.org3.example.com
docker volume rm ${COMPOSE_PROJECT_NAME}_peer0.org3.example.com
#

cd $PWD