package containerlabiam

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	// "github.com/aws/aws-sdk-go-v2/service/s3/types"
)

func CreateRole() {
	
	policyDocument := `{
		"Version": "2012-10-17",
		"Statement": [
		  {
			"Effect": "Allow",
			"Principal": {
			  "Service": "ec2.amazonaws.com"
			},
			"Action": "sts:AssumeRole"
		  }
		]
	  }`
	  
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		panic(err)
	}
	client := iam.NewFromConfig(cfg, func (o *iam.Options) {
		o.Region = "us-west-1"
	})
	roleOutPut, err := client.CreateRole(context.Background(), &iam.CreateRoleInput{ 
		AssumeRolePolicyDocument: &policyDocument,
		RoleName: aws.String("containerlab_role"),
		Description:  aws.String("Containerlab role"),

	})
	if err != nil {
		panic(err)
	}
	fmt.Printf("%s \n", *roleOutPut.Role.RoleName)
	fmt.Printf("%s \n", *roleOutPut.Role.Arn)
}

func CreatePolicy() {
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		panic(err)
	}
	client := iam.NewFromConfig(cfg, func (o *iam.Options) {
		o.Region = "us-west-1"
	})

	policyDocument := `{
		"Version": "2012-10-17",
		"Statement": [
		  {
			"Effect": "Allow",
			"Action": [
			  "s3:GetObject",
			  "s3:PutObject"
			],
			"Resource": "arn:aws:s3:::*/*"
		  }
		]
	  }`
	  
	policyOutput, err := client.CreatePolicy(context.Background(), &iam.CreatePolicyInput{
		PolicyDocument: &policyDocument,
		PolicyName: aws.String("containerlab_policy"),
		Description:  aws.String("Containerlab policy"),
	})
	if err != nil {
		panic(err)
	}
	fmt.Printf("%s \n", *policyOutput.Policy.Arn)
	fmt.Printf("%s \n", *policyOutput.Policy.PolicyName)
}