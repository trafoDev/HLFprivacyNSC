MYHOME=$PWD
. env.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
. scripts/utils.sh
. scripts/envVar.sh
#
export CHANNEL=channel.n3
#
./network.sh deployNewCC -ccn marblesNoPDC3 -ccp ../fabric-samples/chaincode/marbles02/go/ \
                      -ccl go -ccep "AND('Org3MSP.peer','Org2MSP.peer')" \
                      -c ${CHANNEL} 



cd $PWD