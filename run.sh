#!/bin/bash

# Note:
# - We Have Total Three Organizations And One Orderer,
#   Each Organization Have One Peer, One Admin And One User.
#   You Can Check 'cryptoConfig.sh' To Check The Way We Are Generating Certificate Files,
#   And You Can Also Check ./docker-compose-fabric-ca-server.yaml To Know The Way We Are Running CA Server.
#   And You Can Generate Certificate Files For Other Organizations Same As We Have Created For Org1 And Org2.
# 
# - You Can Create Network With Multiple More Organizations, For That You Just Need To Modify ./configtx/Configtx.yaml File,
#   Along With This You Also Have To Generate Certificate Files For Orgs,
#   And Then You Just Need To Run Peer And For That You Can Check ./docker-compose.yaml File.
# - We Have Used Single CA For Orderer, Org1 And Org2.
#   So The Place Where You Need To Provide CA Cert Or Root CA Cert You Can Use Below Given Cert
#   CA Cert Path: /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/ca-cert.pem
#   Basically We Have Just Pasted This Same Cert In Every MSP And TLS Directory Of Peer And User,
#   It Seem Repetitive But Fabric Follows This Architecture.
#
# - Add Anchor Peer In Network, To Enable Discovery Service In Network.
#   When You Will Interact With ChainCode Using Fabric Gateway Or SDK So At That Time You Will Be Requiring Discovery To Be Enabled.
#   You Can Also Interact With ChainCode Using Fabric Gateway Or SDK Without Discovery Service,
#   But In That Situation You Will Have To Define Endorse Peers, Along With This It Is Highly Suggested To Add AtLeast Single Anchor Peer.
#   To Enable Anchor Peer You Can Use 'addAnchorPeer.sh' Script, You Can Create Anchor Peer In Both Organizations Or Only In Single Organization.
#   Creating Multiple Anchor Peer Or Creating Anchor Peer In Each Organization Provides Fault Tolerance.
# 
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

# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_LOCALMSPID="Org3MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org3/admin.org3/msp/cacerts/0-0-0-0-7052.pem
# export CORE_PEER_MSPCONFIGPATH=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org3/admin.org3/msp
# export CORE_PEER_ADDRESS=localhost:11051

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
#     --version 1.0 --package-id tempchaincode_1.0:1ff13035c120d2e8486b4a4f5558a21e42f2bdc97abffd8f4c28f12fe4718469 --sequence 1 --tls \
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
