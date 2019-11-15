# Preparation
create buckets and instance
```
gsutil mb -l europe-west3 gs://pxb-test/
gcloud compute instances create mykola-pxb --boot-disk-size=200GB --machine-type=c2-standard-16 --preemptible --zone=us-east1-c --image=ubuntu-1804-bionic-v20191002 --image-project=ubuntu-os-cloud
gcloud compute ssh mykola-pxb
```

prepare data
```
sudo su -
wget https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-8.0.16-7/binary/debian/bionic/x86_64/Percona-Server-8.0.16-7-r613e312-bionic-x86_64-bundle.tar
for i in $(seq 1 30); do cat Percona-Server-8.0.16-7-r613e312-bionic-x86_64-bundle.tar >> test.tar; done
```

# Run backups
## gsutil
prepare
```
export AWS_ACCESS_KEY_ID=GOOGxxx
export AWS_SECRET_ACCESS_KEY=xxx
export AWS_DEFAULT_REGION=europe-west3
gcloud auth login
```
gsutil from US to EU, S3 protocol
```
cat test.tar | pv -a | time gsutil cp - gs://pxb-test/test-gsutil.tar
81.14user 43.53system 24:12.75elapsed 8%CPU (0avgtext+0avgdata 252016maxresident)k
0inputs+32outputs (0major+16012185minor)pagefaults 0swaps
```

## AWS CLI
AWS CLI from US to EU, S3 protocol
```
snap install aws-cli --classic
apt install pv
aws s3 ls --endpoint-url https://storage.googleapis.com s3://pxb-test
cat test.tar | pv -a | time aws s3 cp --endpoint-url https://storage.googleapis.com - s3://pxb-test/test-awscli.tar
upload failed: - to s3://pxb-test/test-awscli.tar An error occurred (InvalidArgument) when calling the CreateMultipartUpload operation: Invalid argument.
```

## MinIO client
MinIO client from US to EU, S3 protocol
```
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
./mc config host add s3 https://storage.googleapis.com GOOGxxx xxx
./mc ls s3/pxb-test
cat test.tar | pv -a | time ./mc pipe s3/pxb-test/test-mc.tar
```

## gof3r
gof3r from US to EU, S3 protocol
```
snap install go --classic
go get github.com/harshavardhana/s3gof3r/gof3r
git -C /root/go/src/github.com/harshavardhana/s3gof3r checkout path-style
go build -o gof3r github.com/harshavardhana/s3gof3r/gof3r
export AWS_REGION=europe-west3
cat test.tar | pv -a | time ./gof3r put --endpoint=storage.googleapis.com --path-style --concurrency=16 -s 10485802 -b pxb-test -k test-gof3r.tar
gof3r error: 400: "Invalid argument."
Command exited with non-zero status 1
```

## xbcloud
prepare
```
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
percona-release enable-only tools release
apt-get update
apt-get install percona-xtrabackup-80
```
xbcloud from US to EU, S3 protocol, default settings
```
xbstream -c test.tar | pv -a | time xbcloud put --s3-endpoint=https://storage.googleapis.com --storage=s3 --s3-bucket=pxb-test test-xbcloudx4.tar
101.71user 21.64system 1:00:46elapsed 3%CPU (0avgtext+0avgdata 98280maxresident)k
0inputs+0outputs (0major+26993minor)pagefaults 0swaps
```
xbcloud from US to EU, S3 protocol, tunned
```
xbstream -c test.tar | pv -a | time xbcloud put --s3-endpoint=https://storage.googleapis.com --parallel=16 --storage=s3 --s3-bucket=pxb-test test-xbcloud16.tar
102.13user 20.94system 4:04.96elapsed 50%CPU (0avgtext+0avgdata 427588maxresident)k
0inputs+0outputs (0major+109582minor)pagefaults 0swaps
```

# rclone
rclone from US to EU, native protocol
```
curl https://rclone.org/install.sh | sudo bash
rclone config
cat test.tar | pv -a | time rclone rcat gs:pxb-test/test-rclone.tar
[14.9MiB/s]
85.34user 44.81system 34:54.83elapsed 6%CPU (0avgtext+0avgdata 62948maxresident)k
0inputs+0outputs (0major+9483minor)pagefaults 0swaps
```
