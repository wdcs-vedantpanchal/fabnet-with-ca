#!/bin/bash

# Note; This Script Is To Quickly Invoke Or Interact With ChainCode
# Operations It Will Perform:
# - Send Simple Transaction
# - Query ChainCode
# Code Of This Script Is Taken From ./run.sh File So For Information Check That File.

export FABRIC_CFG_PATH=$PWD/../config/

# Exporting ENV To Interact With peer0.org0
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org1/admin.org1/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org1/admin.org1/msp
export CORE_PEER_ADDRESS=localhost:7051

# # Exporting ENV To Interact With peer0.org1
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_LOCALMSPID="Org2MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org2/admin.org2/msp/cacerts/0-0-0-0-7052.pem
# export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org2/admin.org2/msp
# export CORE_PEER_ADDRESS=localhost:9051

# # Exporting ENV To Interact With peer0.org2
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_LOCALMSPID="Org3MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org3/admin.org3/msp/cacerts/0-0-0-0-7052.pem
# export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org3/admin.org3/msp
# export CORE_PEER_ADDRESS=localhost:11051

# # To Invoke Chaincode Method
# peer chaincode invoke -o localhost:9050 --ordererTLSHostnameOverride orderer2.example.com --tls \
#     --cafile $PWD/../crypto-config/orderer/peer2.orderer/tls/ca.crt --channelID tempchannel10001 --name tempchaincode \
#     --peerAddresses localhost:7051 --tlsRootCertFiles "$PWD"/../crypto-config/org1/peer0.org1/tls/ca.crt \
#     --peerAddresses localhost:9051 --tlsRootCertFiles "$PWD"/../crypto-config/org2/peer0.org2/tls/ca.crt \
#     --peerAddresses localhost:11051 --tlsRootCertFiles "$PWD"/../crypto-config/org3/peer0.org3/tls/ca.crt \
#     -c '{"function":"TempEventCaller","Args":[]}'

# To Invoke Chaincode Method
peer chaincode invoke -o localhost:9050 --ordererTLSHostnameOverride orderer2.example.com --tls \
    --cafile $PWD/../crypto-config/orderer/peer2.orderer/tls/ca.crt --channelID tempchannel10001 --name tempchaincode2 --peerAddresses localhost:7051 \
    --tlsRootCertFiles "$PWD"/../crypto-config/org1/peer0.org1/tls/ca.crt -c '{"function":"TempEventCaller","Args":[]}'

## To Query Chaincode Data
# peer chaincode query -C tempchannel -n tempchaincode -c '{"Args":["GetData","tempdata"]}'
