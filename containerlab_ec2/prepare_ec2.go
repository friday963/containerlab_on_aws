package containerlab_ec2

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
)

func CreateInstance() {
	// Create a new AWS SDK configuration
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		fmt.Println("Error loading AWS SDK configuration:", err)
		return
	}

	keyPairName := "containerlab-key-pair"


	createKeyPairInput := &ec2.CreateKeyPairInput{
		KeyName: &keyPairName,
	}

	// Create an EC2 client
	client := ec2.NewFromConfig(cfg, func(o *ec2.Options) {
		o.Region = "us-west-1"
	})

	createKeyPairOutput, err := client.CreateKeyPair(context.Background(), createKeyPairInput)
	if err != nil {
		fmt.Println("Error creating key pair:", err)
		return
	}
	// Get the private key material
	privateKey := *createKeyPairOutput.KeyMaterial
	fmt.Println("Created key pair with private key:\n", privateKey)


	// Specify the details of the EC2 instance you want to create
	instanceInput := &ec2.RunInstancesInput{
		ImageId:      aws.String("ami-04669a22aad391419"),     // Replace with your desired AMI ID
		InstanceType: types.InstanceTypeT2Micro, // Replace with your desired instance type
		MinCount:     aws.Int32(1),
		MaxCount:     aws.Int32(1),
		KeyName:      &keyPairName,

	}

	// Create the EC2 instance
	runResult, err := client.RunInstances(context.Background(), instanceInput)
	if err != nil {
		fmt.Println("Error creating EC2 instance:", err)
		return
	}

	// Get the instance ID of the newly created instance
	instanceID := runResult.Instances[0].InstanceId
	fmt.Println("Created EC2 instance with ID:", instanceID)
}
