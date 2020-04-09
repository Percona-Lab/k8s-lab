package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"runtime"

	"github.com/rlmcpherson/s3gof3r"
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

	s3 := s3gof3r.New(endpoint, s3gof3r.Keys{
		AccessKey: accessKey,
		SecretKey: secretKey,
	})
	b := s3.Bucket(bucket)

	conf := s3gof3r.DefaultConfig
	conf.Concurrency = threads
	conf.PartSize = int64(partSize)
	conf.PathStyle = true
	w, err := b.PutWriter(dest, nil, conf)
	if err != nil {
		fmt.Println(err)
		return
	}

	n, err := io.Copy(w, reader)
	if err != nil {
		fmt.Println(err)
		return
	}
	if err = w.Close(); err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("Successfully uploaded bytes: ", n)
}
