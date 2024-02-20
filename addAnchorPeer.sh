#!/bin/bash

export FABRIC_CFG_PATH=$PWD/config/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
# We Can Also Do Something Like This,
# export CORE_PEER_TLS_ROOTCERT_FILE=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem
# Above Used Path Contains The Same Cert As Below Used Path,
# Under The Actually We Have Just Copied Below Given Cert From Above Given Path.
export CORE_PEER_TLS_ROOTCERT_FILE=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/admin.org1/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/admin.org1/msp
export CORE_PEER_ADDRESS=localhost:7051

# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_LOCALMSPID="Org2MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org2/admin.org2/msp/cacerts/0-0-0-0-7052.pem
# export CORE_PEER_MSPCONFIGPATH=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org2/admin.org2/msp
# export CORE_PEER_ADDRESS=localhost:9051

channelName="tempchannel"
caCertFilePath=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem
ordererAddress="localhost:7050"
ordererTLSHostname="orderer.example.com"

mspId="Org1MSP"
host="peer0.org1.example.com"
port="7051"

# mspId="Org2MSP"
# host="peer0.org2.example.com"
# port="9051"

# Fetching Config Block From Orderer
./bin/peer channel fetch config config_block.pb -o $ordererAddress --ordererTLSHostnameOverride $ordererTLSHostname -c $channelName --tls --cafile $caCertFilePath

# Converting Config Block To JSON Form From ProtoBuf
configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json

# Modifying Config File
jq .data.data[0].payload.data.config config_block.json >"$mspId"_config.json
jq '.channel_group.groups.Application.groups.'$mspId'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$host'","port": '$port'}]},"version": "0"}}' "$mspId"_config.json >$mspId"_modified_config.json"

# Converting JSON Form Config File To ProtoBuf Form 
configtxlator proto_encode --input "$mspId"_config.json --type common.Config --output original_config.pb

# Converting JSON Form Modified Config File To ProtoBuf Form
configtxlator proto_encode --input $mspId"_modified_config.json" --type common.Config --output modified_config.pb

# Compute Update Or Difference Between Modified And Unmodified Config File
configtxlator compute_update --channel_id $channelName --original original_config.pb --updated modified_config.pb --output config_update.pb

# Converting ProtoBuf Form Config Update File To JSON Form
configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json

# Generating Envelope File
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$channelName'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json

# Converting JSON Form Envelope File To ProtoBuf Form 
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output $mspId"_anchor.tx"

peer channel update -o $ordererAddress --ordererTLSHostnameOverride $ordererTLSHostname -c $channelName -f $mspId"_anchor.tx" --tls --cafile $caCertFilePath