#!/bin/bash

# Note: This Script Is To Quickly Create A New Channel.
# Operations It Will Perform:
# - Create Genesis Block For Channel
# - Orderer Nodes Joins Channel
# - Orgs Peers Joins Channel
# Code Of This Script Is Taken From ./run.sh File So For Information Check That File.

channelName="tempchannel10001"

# To Generate Genesis Block For Channel
export FABRIC_CFG_PATH=$PWD/../configtx
configtxgen -profile ChannelUsingRaft -outputBlock ./"$channelName".block -channelID $channelName
echo -e "Genesis Block For Channel $channelName Created \n"

## Orderer Peers Joining Channel

# Exporting ENV To Interact With Orderer
export ORDERER_ADMIN_TLS_SIGN_CERT=$PWD/../crypto-config/orderer/peer0.orderer/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$PWD/../crypto-config/orderer/peer0.orderer/tls/server.key
caCertPath=$PWD/../crypto-config/orderer/peer0.orderer/tls/ca.crt
ordererAdminListenAddress=localhost:7053

# To Join Orderer Node
osnadmin channel join --channelID $channelName --config-block ./"$channelName".block -o $ordererAdminListenAddress \
    --ca-file "$caCertPath" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" \
    --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# To List Channels Throught Which Orderer Node Is Connected
osnadmin channel list -o $ordererAdminListenAddress --ca-file "$caCertPath" \
    --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# Exporting ENV To Interact With Orderer1
export ORDERER_ADMIN_TLS_SIGN_CERT=$PWD/../crypto-config/orderer/peer2.orderer/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$PWD/../crypto-config/orderer/peer2.orderer/tls/server.key
caCertPath=$PWD/../crypto-config/orderer/peer1.orderer/tls/ca.crt
ordererAdminListenAddress=localhost:8053

# To Join Orderer1 Node
osnadmin channel join --channelID $channelName --config-block ./"$channelName".block -o $ordererAdminListenAddress \
    --ca-file $caCertPath --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" \
    --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# To List Channels Through Which Orderer1 Node Is Connected
osnadmin channel list -o $ordererAdminListenAddress --ca-file "$caCertPath" \
    --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# Exporting ENV To Interact With Orderer2
export ORDERER_ADMIN_TLS_SIGN_CERT=$PWD/../crypto-config/orderer/peer1.orderer/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$PWD/../crypto-config/orderer/peer1.orderer/tls/server.key
caCertPath=$PWD/../crypto-config/orderer/peer2.orderer/tls/ca.crt
ordererAdminListenAddress=localhost:9053

# To Join Orderer2 Node
osnadmin channel join --channelID $channelName --config-block ./"$channelName".block -o $ordererAdminListenAddress \
    --ca-file $caCertPath --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" \
    --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# To List Channels Through Which Orderer2 Node Is Connected
osnadmin channel list -o $ordererAdminListenAddress --ca-file "$caCertPath" \
    --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

## Orgs Peer Joining Channel

export FABRIC_CFG_PATH=$PWD/../config/

# Exporting ENV To Interact With peer0.org0
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org1/admin.org1/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org1/admin.org1/msp
export CORE_PEER_ADDRESS=localhost:7051

peer channel join -b ./"$channelName".block
peer channel list

# Exporting ENV To Interact With peer0.org1
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org2/admin.org2/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org2/admin.org2/msp
export CORE_PEER_ADDRESS=localhost:9051

peer channel join -b ./"$channelName".block
peer channel list

# Exporting ENV To Interact With peer0.org2
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org3/admin.org3/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org3/admin.org3/msp
export CORE_PEER_ADDRESS=localhost:11051

peer channel join -b ./"$channelName".block
peer channel list
