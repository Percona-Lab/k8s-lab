package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

func main() {
	// common part for all drivers
	endpoint := os.Args[1]
	accessKey := os.Args[2]
	secretKey := os.Args[3]
	bucket := os.Args[4]
	dest := "stream"
	// partSize is set via AWS_CONFIG_FILE=./aws-config
	// threads is set via AWS_CONFIG_FILE=./aws-config
	reader := bufio.NewReader(os.Stdin)
	fmt.Println("Starting upload")

	os.Setenv("AWS_CONFIG_FILE", "./aws-config")
	s, err := session.NewSession(&aws.Config{
		Endpoint:    aws.String(endpoint),
		Region:      aws.String("us-east-1"),
		Credentials: credentials.NewStaticCredentials(accessKey, secretKey, ""),
	})
	if err != nil {
		fmt.Println(err)
		return
	}

	uploader := s3manager.NewUploader(s)
	r, err := uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(dest),
		Body:   reader,
	})
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("Successfully upload location: ", r.Location)
}
