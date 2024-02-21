#!/bin/bash

# Note: This Script Is For Generating Crypto Material For Organizations And Orderers Using Fabric CA.

# To Create 'crypto-config' Directory If It Does Not exist
if [ ! -d ./crypto-config ]; then
    echo "Creating crypto-config Directory"
    mkdir -m 777 crypto-config
fi

# To Start Fabric CA Server
docker compose -f ./docker-compose-fabric-ca-server.yml up -d
sleep 5

sudo chmod -R 777 crypto-config
cd crypto-config/crypto/ || exit 1

tlsCert=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/tls-cert.pem

# Enrolling CA Admin Certificates
sudo ../../bin/fabric-ca-client enroll -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052 --home . --tls.certfiles $tlsCert

# Creating config.yaml File Which Will Be Stored In Every MSP Directory Of Peer,Admin And User
echo "NodeOUs:
        Enable: true
        ClientOUIdentifier:
            Certificate: cacerts/0-0-0-0-7052.pem
            OrganizationalUnitIdentifier: client
        PeerOUIdentifier:
            Certificate: cacerts/0-0-0-0-7052.pem
            OrganizationalUnitIdentifier: peer
        AdminOUIdentifier:
            Certificate: cacerts/0-0-0-0-7052.pem
            OrganizationalUnitIdentifier: admin
        OrdererOUIdentifier:
            Certificate: cacerts/0-0-0-0-7052.pem
            OrganizationalUnitIdentifier: orderer" >../config.yaml

### Registration Of Org1 Certificates
# Registering peer0.org1
sudo ../../bin/fabric-ca-client register --home ./ --id.name peer0.org1 --id.secret peer0.org1pw --id.type peer \
    --id.attrs tempdata=tempop.peer:ecert --tls.certfiles $tlsCert

# Enrolling peer0.org1
sudo ../../bin/fabric-ca-client enroll --home ../org1/peer0.org1 -u https://peer0.org1:peer0.org1pw@0.0.0.0:7052 \
    --csr.cn peer0.org1.example.com --csr.hosts peer0.org1.example.com --csr.hosts localhost --csr.names OU=Org1 \
    --enrollment.profile tls --tls.certfiles $tlsCert

# Registering admin.org1
sudo ../../bin/fabric-ca-client register --home ./ --id.name admin.org1 --id.secret admin.org1pw --id.type admin \
    --id.attrs tempdata=tempop.admin:ecert --tls.certfiles $tlsCert

# Enrolling admin.org1
sudo ../../bin/fabric-ca-client enroll --home ../org1/admin.org1 -u https://admin.org1:admin.org1pw@0.0.0.0:7052 \
    --csr.cn admin.org1.example.com --csr.names OU=Org1 --tls.certfiles $tlsCert

# Registering user1.org1
sudo ../../bin/fabric-ca-client register --home ./ --id.name user1.org1 --id.secret user1.org1pw --id.type user \
    --id.attrs tempdata=tempop.user:ecert --tls.certfiles ./tls-cert.pem

# Enrolling admin.org1
sudo ../../bin/fabric-ca-client enroll --home ../org1/user1.org1 -u https://user1.org1:user1.org1pw@0.0.0.0:7052 \
    --csr.cn user1.org1.example.com --csr.names OU=Org1 --tls.certfiles $tlsCert

sudo chmod -R 777 ../org1
mkdir ../org1/peer0.org1/tls

cp ../org1/peer0.org1/msp/tlscacerts/* ../org1/peer0.org1/tls/ca.crt
cp ../org1/peer0.org1/msp/signcerts/* ../org1/peer0.org1/tls/server.crt
cp ../org1/peer0.org1/msp/keystore/* ../org1/peer0.org1/tls/server.key

cp ../org1/peer0.org1/msp/tlscacerts/* ../org1/peer0.org1/msp/cacerts/0-0-0-0-7052.pem

mv ../org1/peer0.org1/msp/keystore/* ../org1/peer0.org1/msp/keystore/private_key
mv ../org1/admin.org1/msp/keystore/* ../org1/admin.org1/msp/keystore/private_key
mv ../org1/user1.org1/msp/keystore/* ../org1/user1.org1/msp/keystore/private_key

cp ../config.yaml ../org1/peer0.org1/msp
cp ../config.yaml ../org1/admin.org1/msp
cp ../config.yaml ../org1/user1.org1/msp

#### Registration Of Org2 Certificates
# Registering peer0.org2
sudo ../../bin/fabric-ca-client register --home ./ --id.name peer0.org2 --id.secret peer0.org2pw --id.type peer \
    --id.attrs tempdata=tempop.peer:ecert --tls.certfiles $tlsCert

# Enrolling peer0.org2
sudo ../../bin/fabric-ca-client enroll --home ../org2/peer0.org2 -u https://peer0.org2:peer0.org2pw@0.0.0.0:7052 \
    --csr.cn peer0.org2.example.com --csr.hosts peer0.org2.example.com --csr.hosts localhost --csr.names OU=Org2 \
    --enrollment.profile tls --tls.certfiles $tlsCert

# Registering admin.org2
sudo ../../bin/fabric-ca-client register --home ./ --id.name admin.org2 --id.secret admin.org2pw --id.type admin \
    --id.attrs tempdata=tempop.admin:ecert --tls.certfiles $tlsCert

# Enrolling admin.org2
sudo ../../bin/fabric-ca-client enroll --home ../org2/admin.org2 -u https://admin.org2:admin.org2pw@0.0.0.0:7052 \
    --csr.cn admin.org2.example.com --csr.names OU=Org2 --tls.certfiles $tlsCert

# Registering user1.org2
sudo ../../bin/fabric-ca-client register --home ./ --id.name user1.org2 --id.secret user1.org2pw --id.type user \
    --id.attrs tempdata=tempop.user:ecert --tls.certfiles ./tls-cert.pem

# Enrolling admin.org2
sudo ../../bin/fabric-ca-client enroll --home ../org2/user1.org2 -u https://user1.org2:user1.org2pw@0.0.0.0:7052 \
    --csr.cn user1.org2.example.com --csr.names OU=Org2 --tls.certfiles $tlsCert

sudo chmod -R 777 ../org2
mkdir ../org2/peer0.org2/tls

cp ../org2/peer0.org2/msp/tlscacerts/* ../org2/peer0.org2/tls/ca.crt
cp ../org2/peer0.org2/msp/signcerts/* ../org2/peer0.org2/tls/server.crt
cp ../org2/peer0.org2/msp/keystore/* ../org2/peer0.org2/tls/server.key

cp ../org2/peer0.org2/msp/tlscacerts/* ../org2/peer0.org2/msp/cacerts/0-0-0-0-7052.pem

mv ../org2/peer0.org2/msp/keystore/* ../org2/peer0.org2/msp/keystore/private_key
mv ../org2/admin.org2/msp/keystore/* ../org2/admin.org2/msp/keystore/private_key
mv ../org2/user1.org2/msp/keystore/* ../org2/user1.org2/msp/keystore/private_key

cp ../config.yaml ../org2/peer0.org2/msp
cp ../config.yaml ../org2/admin.org2/msp
cp ../config.yaml ../org2/user1.org2/msp

#### Registration Of Org3 Certificates
# Registering peer0.org3
sudo ../../bin/fabric-ca-client register --home ./ --id.name peer0.org3 --id.secret peer0.org3pw --id.type peer \
    --id.attrs tempdata=tempop.peer:ecert --tls.certfiles $tlsCert

# Enrolling peer0.org3
sudo ../../bin/fabric-ca-client enroll --home ../org3/peer0.org3 -u https://peer0.org3:peer0.org3pw@0.0.0.0:7052 \
    --csr.cn peer0.org3.example.com --csr.hosts peer0.org3.example.com --csr.hosts localhost --csr.names OU=org3 \
    --enrollment.profile tls --tls.certfiles $tlsCert

# Registering admin.org3
sudo ../../bin/fabric-ca-client register --home ./ --id.name admin.org3 --id.secret admin.org3pw --id.type admin \
    --id.attrs tempdata=tempop.admin:ecert --tls.certfiles $tlsCert

# Enrolling admin.org3
sudo ../../bin/fabric-ca-client enroll --home ../org3/admin.org3 -u https://admin.org3:admin.org3pw@0.0.0.0:7052 \
    --csr.cn admin.org3.example.com --csr.names OU=org3 --tls.certfiles $tlsCert

# Registering user1.org3
sudo ../../bin/fabric-ca-client register --home ./ --id.name user1.org3 --id.secret user1.org3pw --id.type user \
    --id.attrs tempdata=tempop.user:ecert --tls.certfiles ./tls-cert.pem

# Enrolling admin.org3
sudo ../../bin/fabric-ca-client enroll --home ../org3/user1.org3 -u https://user1.org3:user1.org3pw@0.0.0.0:7052 \
    --csr.cn user1.org3.example.com --csr.names OU=org3 --tls.certfiles $tlsCert

sudo chmod -R 777 ../org3
mkdir ../org3/peer0.org3/tls

cp ../org3/peer0.org3/msp/tlscacerts/* ../org3/peer0.org3/tls/ca.crt
cp ../org3/peer0.org3/msp/signcerts/* ../org3/peer0.org3/tls/server.crt
cp ../org3/peer0.org3/msp/keystore/* ../org3/peer0.org3/tls/server.key

cp ../org3/peer0.org3/msp/tlscacerts/* ../org3/peer0.org3/msp/cacerts/0-0-0-0-7052.pem

mv ../org3/peer0.org3/msp/keystore/* ../org3/peer0.org3/msp/keystore/private_key
mv ../org3/admin.org3/msp/keystore/* ../org3/admin.org3/msp/keystore/private_key
mv ../org3/user1.org3/msp/keystore/* ../org3/user1.org3/msp/keystore/private_key

cp ../config.yaml ../org3/peer0.org3/msp
cp ../config.yaml ../org3/admin.org3/msp
cp ../config.yaml ../org3/user1.org3/msp

#### Registration Of Orderer Certificates
# Registering peer0.orderer
sudo ../../bin/fabric-ca-client register --home ./ --id.name peer0.orderer --id.secret peer0.ordererpw --id.type orderer \
    --id.attrs tempdata=tempop.orderer:ecert --tls.certfiles $tlsCert

# Enrolling peer0.orderer
sudo ../../bin/fabric-ca-client enroll --home ../orderer/peer0.orderer -u https://peer0.orderer:peer0.ordererpw@0.0.0.0:7052 \
    --csr.cn orderer.example.com --csr.hosts orderer.example.com --csr.hosts localhost --csr.names OU=orderer \
    --enrollment.profile tls --tls.certfiles $tlsCert

# Registering admin.orderer
sudo ../../bin/fabric-ca-client register --home ./ --id.name admin.orderer --id.secret admin.ordererpw --id.type admin \
    --id.attrs tempdata=tempop.admin:ecert --tls.certfiles $tlsCert

# Enrolling admin.orderer
sudo ../../bin/fabric-ca-client enroll --home ../orderer/admin.orderer -u https://admin.orderer:admin.ordererpw@0.0.0.0:7052 \
    --csr.cn admin.orderer.example.com --csr.names OU=orderer --tls.certfiles $tlsCert

sudo chmod -R 777 ../orderer
mkdir ../orderer/peer0.orderer/tls

cp ../orderer/peer0.orderer/msp/tlscacerts/* ../orderer/peer0.orderer/tls/ca.crt
cp ../orderer/peer0.orderer/msp/signcerts/* ../orderer/peer0.orderer/tls/server.crt
cp ../orderer/peer0.orderer/msp/keystore/* ../orderer/peer0.orderer/tls/server.key

cp ../orderer/peer0.orderer/msp/tlscacerts/* ../orderer/peer0.orderer/msp/cacerts/0-0-0-0-7052.pem

mv ../orderer/peer0.orderer/msp/keystore/* ../orderer/peer0.orderer/msp/keystore/private_key
mv ../orderer/admin.orderer/msp/keystore/* ../orderer/admin.orderer/msp/keystore/private_key

cp ../config.yaml ../orderer/peer0.orderer/msp
cp ../config.yaml ../orderer/admin.orderer/msp

# Registering peer1.orderer
sudo ../../bin/fabric-ca-client register --home ./ --id.name peer1.orderer --id.secret peer1.ordererpw --id.type orderer \
    --id.attrs tempdata=tempop.orderer:ecert --tls.certfiles $tlsCert

# Enrolling peer1.orderer
sudo ../../bin/fabric-ca-client enroll --home ../orderer/peer1.orderer -u https://peer1.orderer:peer1.ordererpw@0.0.0.0:7052 \
    --csr.cn orderer1.example.com --csr.hosts orderer1.example.com --csr.hosts localhost --csr.names OU=orderer \
    --enrollment.profile tls --tls.certfiles $tlsCert

sudo chmod -R 777 ../orderer
mkdir ../orderer/peer1.orderer/tls

cp ../orderer/peer1.orderer/msp/tlscacerts/* ../orderer/peer1.orderer/tls/ca.crt
cp ../orderer/peer1.orderer/msp/signcerts/* ../orderer/peer1.orderer/tls/server.crt
cp ../orderer/peer1.orderer/msp/keystore/* ../orderer/peer1.orderer/tls/server.key

cp ../orderer/peer1.orderer/msp/tlscacerts/* ../orderer/peer1.orderer/msp/cacerts/0-0-0-0-7052.pem

mv ../orderer/peer1.orderer/msp/keystore/* ../orderer/peer1.orderer/msp/keystore/private_key

cp ../config.yaml ../orderer/peer1.orderer/msp

# Registering peer2.orderer
sudo ../../bin/fabric-ca-client register --home ./ --id.name peer2.orderer --id.secret peer2.ordererpw --id.type orderer \
    --id.attrs tempdata=tempop.orderer:ecert --tls.certfiles $tlsCert

# Enrolling peer2.orderer
sudo ../../bin/fabric-ca-client enroll --home ../orderer/peer2.orderer -u https://peer2.orderer:peer2.ordererpw@0.0.0.0:7052 \
    --csr.cn orderer2.example.com --csr.hosts orderer2.example.com --csr.hosts localhost --csr.names OU=orderer \
    --enrollment.profile tls --tls.certfiles $tlsCert

sudo chmod -R 777 ../orderer
mkdir ../orderer/peer2.orderer/tls

cp ../orderer/peer2.orderer/msp/tlscacerts/* ../orderer/peer2.orderer/tls/ca.crt
cp ../orderer/peer2.orderer/msp/signcerts/* ../orderer/peer2.orderer/tls/server.crt
cp ../orderer/peer2.orderer/msp/keystore/* ../orderer/peer2.orderer/tls/server.key

cp ../orderer/peer2.orderer/msp/tlscacerts/* ../orderer/peer2.orderer/msp/cacerts/0-0-0-0-7052.pem

mv ../orderer/peer2.orderer/msp/keystore/* ../orderer/peer2.orderer/msp/keystore/private_key

cp ../config.yaml ../orderer/peer2.orderer/msp

# docker compose -f ./docker-compose-fabric-ca-server.yml down
# sleep 2
# rm -rf crypto-config

# sudo ../../bin/fabric-ca-client enroll --home ../org1/user1.org1 -u https://user1.org1:user1.org1pw@0.0.0.0:7052 \
#     --tls.certfiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/tls-cert.pem
