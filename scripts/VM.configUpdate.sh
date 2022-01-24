#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# import utils
. scripts/VM.envVar.sh

# fetchChannelConfig <org> <channel_id> <output_json>
# Writes the current channel config for a given channel to a JSON file
# NOTE: this must be run in a CLI container since it requires configtxlator 
fetchChannelConfig() {
  ORG=$1
  CHANNEL=$2
  OUTPUT=$3

  setGlobals $ORG

  infoln "Fetching the most recent configuration block for the channel"
  set -x
  peer channel fetch config $WRKDIR/config_block.pb -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride orderer0.org${ORG}.example.com -c $CHANNEL --tls --cafile $ORDERER_CA
  { set +x; } 2>/dev/null

  infoln "Decoding config block to JSON and isolating config to ${OUTPUT}"
  set -x
  configtxlator proto_decode --input $WRKDIR/config_block.pb --type common.Block | jq .data.data[0].payload.data.config >$WRKDIR/"${OUTPUT}"
  { set +x; } 2>/dev/null
}

# createConfigUpdate <channel_id> <original_config.json> <modified_config.json> <output.pb>
# Takes an original and modified config, and produces the config update tx
# which transitions between the two
# NOTE: this must be run in a CLI container since it requires configtxlator 
createConfigUpdate() {
  CHANNEL=$1
  ORIGINAL=$2
  MODIFIED=$3
  OUTPUT=$4

  #set -x
  configtxlator proto_encode --input $WRKDIR/"${ORIGINAL}" --type common.Config >$WRKDIR/original_config.pb
  configtxlator proto_encode --input $WRKDIR/"${MODIFIED}" --type common.Config >$WRKDIR/modified_config.pb
  configtxlator compute_update --channel_id "${CHANNEL}" --original $WRKDIR/original_config.pb --updated $WRKDIR/modified_config.pb >$WRKDIR/config_update.pb
  configtxlator proto_decode --input $WRKDIR/config_update.pb --type common.ConfigUpdate >$WRKDIR/config_update.json
  echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat $WRKDIR/config_update.json)'}}}' | jq . >$WRKDIR/config_update_in_envelope.json
  configtxlator proto_encode --input $WRKDIR/config_update_in_envelope.json --type common.Envelope >$WRKDIR/"${OUTPUT}"
  { set +x; } 2>/dev/null
}

# signConfigtxAsPeerOrg <org> <configtx.pb>
# Set the peerOrg admin of an org and sign the config update
signConfigtxAsPeerOrg() {
  ORG=$1
  CONFIGTXFILE=$2
  setGlobals $ORG
  set -x
  peer channel signconfigtx -f ${WRKDIR}/"${CONFIGTXFILE}"
  { set +x; } 2>/dev/null
}
