package main

import (
	"bytes"
	"crypto/x509"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	// "github.com/hyperledger/fabric-chaincode-go/pkg/attrmgr"
	"github.com/hyperledger/fabric-gateway/pkg/client"
	"github.com/hyperledger/fabric-gateway/pkg/identity"

	// "google.golang.org/protobuf/proto"

	// peer "github.com/hyperledger/fabric-protos-go-apiv2/peer"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

const (
	peer1TLSFilePath    = "/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/peer0.org1/tls/ca.crt"
	peer1Endpoint       = "localhost:7051"
	peer1Name           = "peer0.org1.example.com"
	user1SignCertPath   = "/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/admin.org1/msp/signcerts/cert.pem"
	user1PrivateKeyPath = "/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org1/admin.org1/msp/keystore/private_key"
	mspID               = "Org1MSP"
)

// const (
// 	peer1TLSFilePath    = "/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org2/peer0.org2/tls/ca.crt"
// 	peer1Endpoint       = "localhost:9051"
// 	peer1Name           = "peer0.org2.example.com"
// 	user1SignCertPath   = "/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org2/admin.org2/msp/signcerts/cert.pem"
// 	user1PrivateKeyPath = "/home/codezeros/Desktop/tempFab/tempopnet/crypto-config/org2/admin.org2/msp/keystore/private_key"
// 	mspID               = "Org2MSP"
// )

func getCertificate(certificatePath string) *x509.Certificate {
	certificateData, err := os.ReadFile(certificatePath)
	if err != nil {
		log.Fatal("failed to read certificate file: ", err)
	}
	certificate, err := identity.CertificateFromPEM(certificateData)
	if err != nil {
		log.Fatal("failed to get certificate from certPem file: ", err)
	}
	return certificate
}

func formatJSON(data []byte) string {
	var prettyJSON bytes.Buffer
	if err := json.Indent(&prettyJSON, data, "", "  "); err != nil {
		panic(fmt.Errorf("failed to parse JSON: %w", err))
	}
	return prettyJSON.String()
}

func getPrivateKeySign(privateKeyPath string) identity.Sign {
	privateKeyData, err := os.ReadFile(privateKeyPath)
	if err != nil {
		log.Fatal("failed to read private key file: ", err)
	}
	privateKey, err := identity.PrivateKeyFromPEM(privateKeyData)
	if err != nil {
		log.Fatal("failed to get private key from keyPem file: ", err)
	}
	sign, err := identity.NewPrivateKeySign(privateKey)
	if err != nil {
		log.Fatal("failed to get sign from private key: ", err)
	}
	return sign
}

func main() {
	tlsCredential, err := credentials.NewClientTLSFromFile(peer1TLSFilePath, peer1Name)
	if err != nil {
		log.Fatal("failed to create TLS credentials: ", err)
	}
	clientConnection, err := grpc.Dial(peer1Endpoint, grpc.WithTransportCredentials(tlsCredential))
	if err != nil {
		log.Fatal("failed to connect to peer: ", err)
	}
	defer clientConnection.Close()

	user1Identity, err := identity.NewX509Identity(mspID, getCertificate(user1SignCertPath))
	if err != nil {
		log.Fatal("failed to generate user1 identity: ", err)
	}
	fabricCient, err := client.Connect(
		user1Identity,
		client.WithSign(getPrivateKeySign(user1PrivateKeyPath)),
		client.WithClientConnection(clientConnection),
		client.WithEvaluateTimeout(5*time.Second),
		client.WithEndorseTimeout(15*time.Second),
		client.WithSubmitTimeout(5*time.Second),
		client.WithCommitStatusTimeout(1*time.Minute),
	)
	if err != nil {
		log.Fatal("failed to connect to peer: ", err)
	}
	defer fabricCient.Close()
	network := fabricCient.GetNetwork("tempchannel")
	contract := network.GetContract("tempchaincode")
	fmt.Println(contract)

	// mrg := attrmgr.New()
	// fmt.Println(mrg.GetAttributesFromCert(getCertificate(user1SignCertPath)))

	fmt.Println(contract.Submit("TempEventCaller"))

	// temp, _ := json.Marshal([]string{"Op Bro101010"})
	// fmt.Println(contract.Submit("StoreDummyData", client.WithArguments("NodeData", "Node4"), client.WithBytesArguments(temp)))

	// resData, err := contract.EvaluateTransaction("GetData", "Node4")
	// fmt.Println(formatJSON(resData), err)

	// temp, _ := json.Marshal([]string{"Op Bro101010111111111"})
	// endorserPeers, _ := json.Marshal([]string{"Org1MSP"})
	// fmt.Println(contract.Submit("StoreRestrictiveData", client.WithBytesArguments(endorserPeers), client.WithArguments("Node4"), client.WithBytesArguments(temp), client.WithEndorsingOrganizations("Org1MSP")))

	/// To Query Chain Data Such As Tx Data And Block
	// qsccContract := network.GetContract("qscc")
	// txDataBytes, err := qsccContract.EvaluateTransaction("GetTransactionByID", "tempchannel", "f9f976fde373d4149a7fb8deb4348b66bfdc2a93742649d17f6d37d79cf0003c")
	// var txData peer.ProcessedTransaction
	// fmt.Println(proto.Unmarshal(txDataBytes, &txData), err)
	// fmt.Printf("%v", txData)

	// temp, _ := json.Marshal([]string{"Op Bro101010"})
	// txProposal, err := contract.NewProposal("StoreDummyData", client.WithArguments("NodeData", "Node2"), client.WithBytesArguments(temp))
	// if err != nil {
	// 	log.Println("failed to create tx proposal: ", err)
	// }
	// txPayload, err := txProposal.Endorse()
	// if err != nil {
	// 	log.Println("failed to endorse tx: ", err)
	// }
	// txCommit, err := txPayload.Submit()
	// if err != nil {
	// 	log.Println("failed to submit tx to orderer: ", err)
	// }
	// fmt.Println(txCommit.Status())

	// temp, _ := json.Marshal([]string{"Op Bro101010"})
	// fmt.Println(contract.Submit("StoreDummyData", client.WithArguments("NodeData", "Node2"), client.WithBytesArguments(temp)))

	// resData, err := contract.EvaluateTransaction("GetData", "Node4")
	// fmt.Println(formatJSON(resData), err)

	// resData, err := contract.EvaluateTransaction("GetDataInRange", "Node1", "Node5")
	// fmt.Println(formatJSON(resData), err)

	// resData, err := contract.EvaluateTransaction("GetDataUsingCompositeKey", "NodeDataNode2Node2")
	// fmt.Println(formatJSON(resData), err)

	// fmt.Println(contract.Submit("StorePrivateData", client.WithArguments("_implicit_org_Org1MSP", "node2Data", "Node Is Running"), client.WithTransient(
	// 	map[string][]byte{"node1Data": []byte("Node Is Active"), "node2Data": []byte("")})))

	// resData, err := contract.EvaluateTransaction("GetPrivateData", "_implicit_org_Org1MSP", "node2Data")
	// fmt.Println(resData, err)
}

/*
discover --configFile conf.yaml --peerTLSCA tls/ca.crt --userKey msp/keystore/ea4f6a38ac7057b6fa9502c2f5f39f182e320f71f667749100fe7dd94c23ce43_sk --userCert msp/signcerts/User1\@org1.example.com-cert.pem  --MSP Org1MSP saveConfig

*/
