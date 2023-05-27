package containerlab_s3

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
)

func CreateBucket() {
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		panic(err)
	}

	client := s3.NewFromConfig(cfg, func(o *s3.Options) {
		o.Region = "us-west-1"
	})
	response, err := client.ListBuckets(context.Background(), nil)
	if err != nil {
		fmt.Println("error while trying to list buckets", err)
	}
	for _, v := range response.Buckets {
		fmt.Println(*v.Name)
	}

	configuration := &types.CreateBucketConfiguration{
		LocationConstraint: "us-west-1",
	}

	_, err = client.CreateBucket(context.Background(), &s3.CreateBucketInput{
		Bucket:                    aws.String("testbucketgo123321123321123"),
		CreateBucketConfiguration: configuration,
	},
	)

	if err != nil {
		fmt.Println("error while trying to create bucket", err)
	}
}
