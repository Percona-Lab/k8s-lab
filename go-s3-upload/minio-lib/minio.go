package main

import (
	"bufio"
	"fmt"
	"os"
	"runtime"

	minio "github.com/minio/minio-go/v6"
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

	s3, err := minio.New(endpoint, accessKey, secretKey, true)
	if err != nil {
		fmt.Println(err)
		return
	}

	n, err := s3.PutObject(bucket, dest, reader, -1, minio.PutObjectOptions{
		PartSize:   uint64(partSize),
		NumThreads: uint(threads),
	})
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("Successfully uploaded bytes: ", n)
}
