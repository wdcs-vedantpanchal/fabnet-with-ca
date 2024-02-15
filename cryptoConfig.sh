#!/bin/bash

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

cp ../config.yaml ../org2/peer0.org2/msp
cp ../config.yaml ../org2/admin.org2/msp
cp ../config.yaml ../org2/user1.org2/msp

#### Registration Of Orderer Certificates
# Registering peer0.org2
sudo ../../bin/fabric-ca-client register --home ./ --id.name peer.orderer --id.secret peer.ordererpw --id.type orderer \
    --id.attrs tempdata=tempop.orderer:ecert --tls.certfiles $tlsCert

# Enrolling peer0.org2
sudo ../../bin/fabric-ca-client enroll --home ../orderer/peer.orderer -u https://peer.orderer:peer.ordererpw@0.0.0.0:7052 \
    --csr.cn orderer.example.com --csr.hosts orderer.example.com --csr.hosts localhost --csr.names OU=orderer \
    --enrollment.profile tls --tls.certfiles $tlsCert

# Registering admin.org2
sudo ../../bin/fabric-ca-client register --home ./ --id.name admin.orderer --id.secret admin.ordererpw --id.type admin \
    --id.attrs tempdata=tempop.admin:ecert --tls.certfiles $tlsCert

# Enrolling admin.org2
sudo ../../bin/fabric-ca-client enroll --home ../orderer/admin.orderer -u https://admin.orderer:admin.ordererpw@0.0.0.0:7052 \
    --csr.cn admin.orderer.example.com --csr.names OU=orderer --tls.certfiles $tlsCert

sudo chmod -R 777 ../orderer
mkdir ../orderer/peer.orderer/tls

cp ../orderer/peer.orderer/msp/tlscacerts/* ../orderer/peer.orderer/tls/ca.crt
cp ../orderer/peer.orderer/msp/signcerts/* ../orderer/peer.orderer/tls/server.crt
cp ../orderer/peer.orderer/msp/keystore/* ../orderer/peer.orderer/tls/server.key

cp ../orderer/peer.orderer/msp/tlscacerts/* ../orderer/peer.orderer/msp/cacerts/0-0-0-0-7052.pem

cp ../config.yaml ../orderer/peer.orderer/msp
cp ../config.yaml ../orderer/admin.orderer/msp

# docker compose -f ./docker-compose-fabric-ca-server.yml down
# sleep 2
# rm -rf crypto-config

# sudo ../../bin/fabric-ca-client enroll --home ../org1/user1.org1 -u https://user1.org1:user1.org1pw@0.0.0.0:7052 \
#     --tls.certfiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/tls-cert.pem
