#!/bin/bash

tlsCert=/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/tls-cert.pem

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
