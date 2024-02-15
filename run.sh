#!/bin/bash

# Note: We Have Used Single CA For Orderer, Org1 And Org2.
# So The Place Where You Need To Provide CA Cert Or Root CA Cert You Can Use Below Given Cert
# CA Cert Path: /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem
# Basically We Have Just Pasted This Same Cert In Every MSP And TLS Directory Of Peer And User,
# It Seem Repetitive But Fabric Follows This Architecture.

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

# # To Generate Genesis Block For Channel
# export FABRIC_CFG_PATH=$PWD/configtx/
# configtxgen -profile ChannelUsingRaft -outputBlock ./tempchannel.block -channelID tempchannel

# # To Join Orderer Node
# export ORDERER_ADMIN_TLS_SIGN_CERT=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.key
# osnadmin channel join --channelID tempchannel --config-block ./tempchannel.block -o localhost:7053 \
#     --ca-file /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/ca.crt --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" \
#     --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# # To List Channels Throught Which Orderer Node Is Connected
# export ORDERER_ADMIN_TLS_SIGN_CERT=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.key
# osnadmin channel list -o localhost:7053 --ca-file /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/ca.crt \
#     --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# # To Join A Channel, Make Sure ENV For This Operation Is Set
# peer channel join -b ./tempchannel.block

## Here We Are Deploying `assetTransfer` Chaincode On Existing Testnet With Two Orgs.
## You Can Even Use It To Deploy Chaincode On Custom Network, Just Need To Add Commands For Other Peers Operation.

# # To Generate Package Of Chaincode
# peer lifecycle chaincode package tempchaincode.tar.gz --path ./tempChaincode --label tempchaincode_1.0

# # To Install A Chaincode On Channel, Make Sure ENV For This Operation Is Set
# peer lifecycle chaincode install  tempchaincode.tar.gz

# # To Get List Of Chaincode Installed
# peer lifecycle chaincode queryinstalled

# # To Approve Chaincode At Organization Level
# # Note: Here For --cafile We Have Used Path Of Actual Or Original CA File To Show You Example,
# # You Can Also Use CA File Path Located In MSP Directory.
# peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID tempchannel --name tempchaincode \
#     --version 1.0 --package-id tempchaincode_1.0:2b965f07c136346ae800e477ac27e79bc67b3b89f17b9dad560c0c143ee1bc51 --sequence 1 --tls \
#     --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem

# # To Check Approvals Of Chaincode
# peer lifecycle chaincode checkcommitreadiness --channelID tempchannel --name tempchaincode --version 1.0 --sequence 1 --tls \
#  --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --output json

# # To Commit Chaincode
# peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID tempchannel --name tempchaincode \
#     --version 1.0 --sequence 1 --tls --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --peerAddresses localhost:7051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem \
#     --peerAddresses localhost:9051 --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem

# # To Get Information About Chaincode Committed On Channel
# peer lifecycle chaincode querycommitted --channelID tempchannel --name tempchaincode

# # To Invoke Chaincode Method
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls \
#     --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --channelID tempchannel --name tempchaincode --peerAddresses localhost:7051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --peerAddresses localhost:9051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem -c '{"function":"TempEventCaller","Args":[]}'

# # To Invoke Chaincode Method
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls \
#     --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --channelID tempchannel --name tempchaincode --peerAddresses localhost:7051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --peerAddresses localhost:9051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem -c '{"function":"StoreDummyData","Args":["nodeData","tempdata","[]"]}'

## To Query Chaincode Data
# peer chaincode query -C tempchannel -n tempchaincode -c '{"Args":["GetData","tempdata"]}'