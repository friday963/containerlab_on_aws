package main

import (
	"github.com/friday963/containerlab_on_aws/containerlab_ec2"
	"github.com/friday963/containerlab_on_aws/containerlab_s3"
)

func main() {
	containerlab_s3.CreateBucket()
	containerlab_ec2.CreateInstance()
}
