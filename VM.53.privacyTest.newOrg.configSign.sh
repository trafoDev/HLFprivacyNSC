MYHOME=$PWD
. env.sh
. scripts/configUpdate.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${HOME}/fabric-samples/config/
#
HOST_ORG=${1}
NEW_ORG=${2}

#
. scripts/utils.sh
. scripts/VM.envVar.sh
#
export CHANNEL=channel.n2
#
setGlobals ${HOST_ORG}
#
signConfigtxAsPeerOrg ${HOST_ORG} org${NEW_ORG}_update_in_envelope.pb
#
cd $PWD