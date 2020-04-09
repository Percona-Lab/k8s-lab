package main

import (
	"bufio"
	"fmt"
	"os"
	"runtime"

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
	dest := os.Args[5]
	partSize := 128 * 1024 * 1024
	threads := int(float64(runtime.NumCPU()) * 1.5)
	reader := bufio.NewReader(os.Stdin)
	fmt.Println("Starting upload")

	s, err := session.NewSession(&aws.Config{
		Endpoint:    aws.String(endpoint),
		Region:      aws.String("us-east-1"),
		Credentials: credentials.NewStaticCredentials(accessKey, secretKey, ""),
	})
	if err != nil {
		fmt.Println(err)
		return
	}

	uploader := s3manager.NewUploader(s, func(u *s3manager.Uploader) {
		u.Concurrency = threads
		u.PartSize = int64(partSize)
	})
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
