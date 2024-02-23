#!/bin/bash

# Note: To Use Discovery Service We Need To Have At-least One Anchor Peer In Network.
# To Add Anchor Peer In Network Check 'addAnchorPeer.sh' File.

mspId="Org1MSP"
serverAddress="localhost:7051"
channelId="tempchannel10001"
chaincodeId="tempchaincode"
caCertPath="/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/peer0.org1/tls/ca.crt"
userSignCertPath=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/admin.org1/msp/signcerts/cert.pem
userKeyPath=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/admin.org1/msp/keystore/private_key

# # To Get List Of Peers In Channel
# discover peers --MSP $mspId --channel $channelId --server $serverAddress --peerTLSCA $caCertPath --userCert $userSignCertPath --userKey $userKeyPath

# To Get Endorser List For Any Chaincode Transaction
discover endorsers --MSP $mspId --channel $channelId --chaincode $chaincodeId --server $serverAddress --peerTLSCA $caCertPath --userCert $userSignCertPath --userKey $userKeyPath
