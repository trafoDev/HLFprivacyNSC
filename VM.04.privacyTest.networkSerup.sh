MYHOME=$PWD
. env.sh
#cleaning the network from previous tests
HOST_ORG=${1}
#
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/envVar.sh
#
#
export CHANNEL=channel.n1
setGlobals ${HOST_ORG}
#
./VM.network.sh deployCC -ccn private -ccp ../fabric-samples/chaincode/marbles02_private/go/ \
                      -ccl go -ccep "AND('Org1MSP.peer','Org2MSP.peer')" \
                      -cccg ../fabric-samples/chaincode/marbles02_private/collections_config.json -c ${CHANNEL}

# Create channel
export CHANNEL=channel.n2
setGlobals ${HOST_ORG}
#
./VM.network.sh deployCC -ccn marblesNoPDC -ccp ../fabric-samples/chaincode/marbles02/go/ \
                      -ccl go -ccep "AND('Org1MSP.peer','Org2MSP.peer')" \
                      -c ${CHANNEL} 

cd $PWD