#!/bin/bash

# Note: This Script Is To Quickly Deploy ChainCode In Channel.
# Operations It Will Perform:
# - Package ChainCode
# - Peers Installs ChainCode
# - Approve ChainCode On Behalf Of Org
# - Commit ChainCode, Here Only Single Peer Out Of All Peers Will Perform This Operation,
#   Once ChainCode Is Committed Then It Is Ready To Interact.
# You Can Deploy ChainCode With Signature Policy, For That Just Uncomment '--signature-policy' Attribute In Commands.
# To Define ChainCode Level Endorsement ChainCode Is Deployed With Signature Policy.
# Code Of This Script Is Taken From ./run.sh File So For Information Check That File.

export FABRIC_CFG_PATH=$PWD/../config/

channelName="tempchannel10001"
chainCodeName="tempchaincode2"
chainCodeSequence=1
chainCodeVersion=1.0
chainCodePath="../tempChaincode"
ordererCACertPath=$PWD/../crypto-config/orderer/peer0.orderer/tls/ca.crt
ordererAddress="localhost:7050"
ordererHostName="orderer.example.com"

# To Generate Package Of ChainCode
peer lifecycle chaincode package "$chainCodeName".tar.gz --path $chainCodePath --label "$chainCodeName"_"$chainCodeVersion"

packageId=$(peer lifecycle chaincode calculatepackageid "$chainCodeName".tar.gz)

echo "Package Id: $packageId"

# Exporting ENV To Interact With peer0.org0
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org1/admin.org1/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org1/admin.org1/msp
export CORE_PEER_ADDRESS=localhost:7051

# To Install A ChainCode On Channel
peer lifecycle chaincode install "$chainCodeName".tar.gz

# To Get List Of ChainCode Installed
peer lifecycle chaincode queryinstalled

# To Approve ChainCode At Organization Level
peer lifecycle chaincode approveformyorg -o $ordererAddress --ordererTLSHostnameOverride $ordererHostName --channelID $channelName --name $chainCodeName \
    --version $chainCodeVersion --package-id "$packageId" --sequence $chainCodeSequence --tls \
    --cafile "$ordererCACertPath" --waitForEvent
# --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer', 'Org3MSP.peer')"

# # To Check Approvals Of Chaincode
peer lifecycle chaincode checkcommitreadiness --channelID $channelName --name $chainCodeName --version $chainCodeVersion --sequence $chainCodeSequence --tls \
    --cafile "$ordererCACertPath" --output json \
    --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer', 'Org3MSP.peer')"

# Exporting ENV To Interact With peer0.org1
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org2/admin.org2/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org2/admin.org2/msp
export CORE_PEER_ADDRESS=localhost:9051

# To Install A ChainCode On Channel
peer lifecycle chaincode install "$chainCodeName".tar.gz

# To Get List Of ChainCode Installed
peer lifecycle chaincode queryinstalled

# To Approve ChainCode At Organization Level
peer lifecycle chaincode approveformyorg -o $ordererAddress --ordererTLSHostnameOverride $ordererHostName --channelID $channelName --name $chainCodeName \
    --version $chainCodeVersion --package-id "$packageId" --sequence $chainCodeSequence --tls \
    --cafile "$ordererCACertPath"
# --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer', 'Org3MSP.peer')"

# To Check Approvals Of Chaincode
peer lifecycle chaincode checkcommitreadiness --channelID $channelName --name $chainCodeName --version $chainCodeVersion --sequence $chainCodeSequence --tls \
    --cafile "$ordererCACertPath" --output json
# --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer', 'Org3MSP.peer')"

# Exporting ENV To Interact With peer0.org2
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/../crypto-config/org3/admin.org3/msp/cacerts/0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/org3/admin.org3/msp
export CORE_PEER_ADDRESS=localhost:11051

# To Install A ChainCode On Channel
peer lifecycle chaincode install "$chainCodeName".tar.gz

# To Get List Of ChainCode Installed
peer lifecycle chaincode queryinstalled

# To Approve ChainCode At Organization Level
peer lifecycle chaincode approveformyorg -o $ordererAddress --ordererTLSHostnameOverride $ordererHostName --channelID $channelName --name $chainCodeName \
    --version $chainCodeVersion --package-id "$packageId" --sequence $chainCodeSequence --tls \
    --cafile "$ordererCACertPath"
# --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer', 'Org3MSP.peer')"

# To Check Approvals Of Chaincode
peer lifecycle chaincode checkcommitreadiness --channelID $channelName --name $chainCodeName --version $chainCodeVersion --sequence $chainCodeSequence --tls \
    --cafile "$ordererCACertPath" --output json
# --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer', 'Org3MSP.peer')"

# To Commit Chaincode
peer lifecycle chaincode commit -o $ordererAddress --ordererTLSHostnameOverride $ordererHostName --channelID $channelName --name $chainCodeName \
    --version $chainCodeVersion --sequence $chainCodeSequence --tls --cafile "$ordererCACertPath" --peerAddresses localhost:7051 \
    --tlsRootCertFiles "$PWD"/../crypto-config/org1/peer0.org1/tls/ca.crt \
    --peerAddresses localhost:9051 --tlsRootCertFiles "$PWD"/../crypto-config/org2/peer0.org2/tls/ca.crt
# --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer', 'Org3MSP.peer')"

# To Get Information About Chaincode Committed On Channel
peer lifecycle chaincode querycommitted --channelID $channelName --name $chainCodeName
