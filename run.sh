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
# configtxgen -profile ChannelUsingRaft -outputBlock ./tempop10.block -channelID tempop10

# # To Join Orderer Node
# export ORDERER_ADMIN_TLS_SIGN_CERT=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.key
# osnadmin channel join --channelID tempop10 --config-block ./tempop10.block -o localhost:7053 \
#     --ca-file /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/ca.crt --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" \
#     --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# # To List Channels Throught Which Orderer Node Is Connected
# export ORDERER_ADMIN_TLS_SIGN_CERT=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/server.key
# osnadmin channel list -o localhost:7053 --ca-file /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/orderer/peer.orderer/tls/ca.crt \
#     --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# # To Join A Channel, Make Sure ENV For This Operation Is Set
# peer channel join -b ./tempop10.block

## Here We Are Deploying `assetTransfer` Chaincode On Existing Testnet With Two Orgs.
## You Can Even Use It To Deploy Chaincode On Custom Network, Just Need To Add Commands For Other Peers Operation.

# # To Generate Package Of Chaincode
# peer lifecycle chaincode package temp11.tar.gz --path /home/codezeros/Desktop/tempFab/fabric-samples/asset-transfer-basic/chaincode-go --label temp11_1.0

# # To Install A Chaincode On Channel, Make Sure ENV For This Operation Is Set
# peer lifecycle chaincode install temp11.tar.gz

# # To Get List Of Chaincode Installed
# peer lifecycle chaincode queryinstalled

# # To Approve Chaincode At Organization Level
# # Note: Here For --cafile We Have Used Path Of Actual Or Original CA File To Show You Example,
# # You Can Also Use CA File Path Located In MSP Directory.
# peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID tempop10 --name temp11 \
#     --version 1.0 --package-id temp11_1.0:b933add4c073212d220eac86263a35de400c9436f983cac69eb0e888ba7782da --sequence 1 --tls \
#     --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem

# # To Check Approvals Of Chaincode
# peer lifecycle chaincode checkcommitreadiness --channelID tempop10 --name temp11 --version 1.0 --sequence 1 --tls \
#  --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --output json

# # To Commit Chaincode
# peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID tempop10 --name temp11 \
#     --version 1.0 --sequence 1 --tls --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --peerAddresses localhost:7051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem \
#     --peerAddresses localhost:9051 --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem

## To Get Information About Chaincode Committed On Channel
# peer lifecycle chaincode querycommitted --channelID tempop10 --name temp11

## To Invoke Chaincode Method
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls \
#     --cafile /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --channelID tempop10 --name temp11 --peerAddresses localhost:7051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem --peerAddresses localhost:9051 \
#     --tlsRootCertFiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem -c '{"function":"InitLedger","Args":[]}'

## To Query Chaincode Data
# peer chaincode query -C tempop10 -n temp11 -c '{"Args":["GetAllAssets"]}'