package main

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/hyperledger/fabric-chaincode-go/pkg/statebased"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type TempContract struct {
	contractapi.Contract
}

const DataCategory = "data"

func (contract *TempContract) StoreDummyData(ctx contractapi.TransactionContextInterface, subDataCategory string, id string, data []string) error {
	dataInBytes, err := json.Marshal(data)
	if err != nil {
		return fmt.Errorf("failed to marshal data: %v", err)
	}
	if err := ctx.GetStub().PutState(id, dataInBytes); err != nil {
		return fmt.Errorf("failed to store data with id as key: %v", err)
	}
	compositeKey, err := ctx.GetStub().CreateCompositeKey(DataCategory, []string{subDataCategory, id})
	if err != nil {
		return fmt.Errorf("failed to create composite key: %v", err)
	}
	if err := ctx.GetStub().PutState(compositeKey, dataInBytes); err != nil {
		return fmt.Errorf("failed to store data with compositeKey as key: %v", err)
	}
	fmt.Println("Data Stored, CompositeKey: ", compositeKey)
	return nil
}

func (contract *TempContract) GetData(ctx contractapi.TransactionContextInterface, id string) ([]string, error) {
	resData := []string{}
	dataInBytes, err := ctx.GetStub().GetState(id)
	if err != nil {
		return resData, fmt.Errorf("failed to get temp data: %v", err)
	}
	if err := json.Unmarshal(dataInBytes, &resData); err != nil {
		fmt.Println(dataInBytes)
		return resData, fmt.Errorf("failed to unmarshal data: %v", err)
	}
	return resData, nil
}

func (contract *TempContract) GetDataInRange(ctx contractapi.TransactionContextInterface, startId string, endId string) ([][]string, error) {
	resData := [][]string{}
	iterator, err := ctx.GetStub().GetStateByRange(startId, endId)
	if err != nil {
		return resData, err
	}
	for iterator.HasNext() {
		queryResData, err := iterator.Next()
		if err != nil {
			return resData, err
		}
		data := []string{}
		if err := json.Unmarshal(queryResData.Value, &data); err != nil {
			return resData, fmt.Errorf("failed to unmarshal query res data: %v", err)
		}
		resData = append(resData, data)
	}

	return resData, nil
}

func (contract *TempContract) GetSubDataCategoryData(ctx contractapi.TransactionContextInterface, subDataCategory string) ([][]string, error) {
	resData := [][]string{}
	iterator, err := ctx.GetStub().GetStateByPartialCompositeKey(DataCategory, []string{subDataCategory})
	if err != nil {
		return resData, err
	}
	for iterator.HasNext() {
		queryResData, err := iterator.Next()
		if err != nil {
			return resData, fmt.Errorf("failed to read from query iterator: %v", err)
		}
		data := []string{}
		if json.Unmarshal(queryResData.Value, &data) != nil {
			return resData, fmt.Errorf("failed to unmarshal queryResData: %v", err)
		}
		resData = append(resData, data)
	}

	return resData, nil
}

func (contract *TempContract) StorePrivateData(ctx contractapi.TransactionContextInterface, collectionId string, id string, data string) error {
	if err := ctx.GetStub().PutPrivateData(collectionId, id, []byte(data)); err != nil {
		return fmt.Errorf("failed to store private data: %v", err)
	}
	return nil
}

func (contract *TempContract) GetPrivateData(ctx contractapi.TransactionContextInterface, collectionId string, id string) (string, error) {
	resData, err := ctx.GetStub().GetPrivateData(collectionId, id)
	if err != nil {
		return "", fmt.Errorf("failed to store private data: %v", err)
	}
	return string(resData), nil
}

func (contract *TempContract) StoreRestrictiveData(ctx contractapi.TransactionContextInterface, endorserOrgs []string, id string, data []string) error {
	stateBasedEndorsementPolicy, err := statebased.NewStateEP(nil)
	if err != nil {
		return fmt.Errorf("failed to create new state endorsement policy instance: %v", err)
	}
	stateBasedEndorsementPolicy.AddOrgs(statebased.RoleTypeMember, endorserOrgs...)
	policy, err := stateBasedEndorsementPolicy.Policy()
	if err != nil {
		return fmt.Errorf("failed to get state based endorsement policy instance bytes data: %v", err)
	}
	ctx.GetStub().SetStateValidationParameter(id, policy)
	dataInBytes, err := json.Marshal(data)
	if err != nil {
		return fmt.Errorf("failed to marshal data: %v", err)
	}
	if err := ctx.GetStub().PutState(id, dataInBytes); err != nil {
		return fmt.Errorf("failed to store restrictive data %v", err)
	}
	return nil
}

func (contract *TempContract) TempEventCaller(ctx contractapi.TransactionContextInterface) error {
	ctx.GetStub().SetEvent("TempEvent", []byte("Op Bro"))
	fmt.Println(ctx.GetClientIdentity().GetAttributeValue("tempdata"))
	// fmt.Println(ctx.GetStub().InvokeChaincode("tempchaincodeop10", [][]byte{[]byte("GetData"), []byte("Node4")}, "tempchannel"))
	return nil
}

func (contract *TempContract) GetAttributeGetter(ctx contractapi.TransactionContextInterface, attributeName string) error {
	fmt.Println(ctx.GetClientIdentity().GetAttributeValue(attributeName))
	return nil
}

func (contract *TempContract) TempChainCodeCaller(ctx contractapi.TransactionContextInterface) error {
	fmt.Println(ctx.GetStub().InvokeChaincode("tempchaincodeop10", [][]byte{[]byte("GetData"), []byte("Node4")}, "tempchannel"))
	return nil
}

func beforeTransaction(ctx contractapi.TransactionContextInterface) error {
	method, args := ctx.GetStub().GetFunctionAndParameters()
	fmt.Printf("\nChainCode Method:%v Args: %v\n", method, args)
	return nil
}

func afterTransaction(ctx contractapi.TransactionContextInterface) error {
	method, _ := ctx.GetStub().GetFunctionAndParameters()
	fmt.Printf("\nExecution Of %v Method Is Completed\n", method)
	return nil
}

func unknownTransaction(ctx contractapi.TransactionContextInterface) error {
	method, args := ctx.GetStub().GetFunctionAndParameters()
	return fmt.Errorf("\nmay be function does not exists or passed args are invalid or in invalid order. \nMethod: %v, Args: %v", method, args)
}

// _implicit_org_Org1MSP
func main() {
	fmt.Println("Starting ChainCode")
	tempContractInstance := new(TempContract)
	tempContractInstance.BeforeTransaction = beforeTransaction
	tempContractInstance.AfterTransaction = afterTransaction
	tempContractInstance.UnknownTransaction = unknownTransaction

	contract, err := contractapi.NewChaincode(tempContractInstance)
	if err != nil {
		log.Panic("failed to create chaincode instance:", err)
	}
	if err := contract.Start(); err != nil {
		log.Panic("failed to start chaincode:", err)
	}
}
