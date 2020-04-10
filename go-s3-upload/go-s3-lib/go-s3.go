package main

import (
	"fmt"
	"os"

	s3 "github.com/jhunt/go-s3"
)

func main() {
	// common part for all drivers
	endpoint := os.Args[1]
	accessKey := os.Args[2]
	secretKey := os.Args[3]
	bucket := os.Args[4]
	dest := os.Args[5]
	partSize := 128 * 1024 * 1024
	//threads := int(float64(runtime.NumCPU()) * 1.5)
	fmt.Println("Starting upload")

	c, err := s3.NewClient(&s3.Client{
		AccessKeyID:     accessKey,
		SecretAccessKey: secretKey,
		Region:          "us-east-1",
		Bucket:          bucket,
		Domain:          endpoint,
	})
	if err != nil {
		fmt.Println(err)
		return
	}

	u, err := c.NewUpload(dest, nil)
	if err != nil {
		fmt.Println(err)
		return
	}

	n, err := u.Stream(os.Stdin, partSize)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("Successfully uploaded bytes: ", n)
}
