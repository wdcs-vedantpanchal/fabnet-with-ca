#!/bin/bash

# # To Create 'crypto-config' Directory If It Does Not exist
# if [ ! -d ./crypto-config ] ; then
#     echo "Creating crypto-config Directory"
#     mkdir -m 777 crypto-config
# fi

# # To Start Fabric CA Server
# docker compose -f ./docker-compose-fabric-ca-server.yml up -d

# cd crypto-config/crypto/ || exit 1

# # Enrolling CA Admin Certificates
# sudo ../../bin/fabric-ca-client enroll -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052 --home . --tls.certfiles ./tls-cert.pem

# # Registering peer0.org1
# sudo ../../bin/fabric-ca-client register --home ./ --csr.cn peer0.org1.example.com --csr.hosts peer0.org1.example.com --csr.names  OU=Org1 \
#  --id.name peer0.org1 --id.secret peer0.org1pw --id.type peer --id.attrs tempdata=tempop --enrollment.profile tls  --tls.certfiles ./tls-cert.pem

# # Enrolling peer0.org1
# sudo ../../bin/fabric-ca-client enroll --home ../org1/peer0.org1 -u https://peer0.org1:peer0.org1pw@0.0.0.0:7052 --enrollment.profile tls --tls.certfiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/tls-cert.pem

# # Registering admin.org1
# sudo ../../bin/fabric-ca-client register --home ./ --csr.cn admin.org1.example.com --csr.names  OU=Org1 \
#  --id.name admin.org1 --id.secret admin.org1pw --id.type admin --id.attrs tempdata=tempop:ecert --tls.certfiles ./tls-cert.pem

# # Enrolling admin.org1
# sudo ../../bin/fabric-ca-client enroll --home ../org1/admin.org1 -u https://admin.org1:admin.org1pw@0.0.0.0:7052 --tls.certfiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/tls-cert.pem

# # Registering user1.org1
# sudo ../../bin/fabric-ca-client register --home ./ --csr.cn user1.org1.example.com --csr.names  OU=Org1 \
#  --id.name user1.org1 --id.secret user1.org1pw --id.type user --id.attrs tempdata=tempop:ecert --tls.certfiles ./tls-cert.pem

# # Enrolling admin.org1
# sudo ../../bin/fabric-ca-client enroll --home ../org1/user1.org1 -u https://user1.org1:user1.org1pw@0.0.0.0:7052 --tls.certfiles /home/codezeros/Desktop/tempFab/tempopnet/crypto-config/crypto/tls-cert.pem