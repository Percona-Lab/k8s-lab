# Preparation
create buckets and EC2 instance
```
aws s3 mb s3://pxb-test --region us-east-1

aws s3 mb s3://pxb-test2 --region eu-central-1

aws ec2 run-instances --region us-east-1 --image-id ami-04b9e92b5572fa0d1 --security-group-ids sg-688c2b1c --instance-type c5.4xlarge --subnet-id subnet-ee06e8e1 --key-name mykola --iam-instance-profile Name=pmm-rds --query 'Instances[].InstanceId' --block-device-mappings '[{"DeviceName":"/dev/sdf","Ebs":{"VolumeSize":40,"DeleteOnTermination":true}}]' --output text
```

prepare data
```ssh ubuntu@18.232.49.6
sudo su -
mkfs.ext2 /dev/nvme0n1
mount /dev/nvme0n1 /mnt
cd /mnt
wget https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-8.0.16-7/binary/debian/bionic/x86_64/Percona-Server-8.0.16-7-r613e312-bionic-x86_64-bundle.tar
for i in $(seq 1 30); do cat Percona-Server-8.0.16-7-r613e312-bionic-x86_64-bundle.tar >> test.tar; done
```

# Run backups
## AWS CLI
AWS CLI inside same region
```
export AWS_ACCESS_KEY_ID=AKIAxxx
export AWS_SECRET_ACCESS_KEY=xxx

snap install aws-cli --classic
apt install pv
aws s3 ls s3://pxb-test
cat test.tar | pv -a | time aws s3 cp - s3://pxb-test/test-awscli.tar
[ 124MiB/s]
115.25user 51.39system 4:11.81elapsed 66%CPU (0avgtext+0avgdata 152476maxresident)k
0inputs+0outputs (0major+1122809minor)pagefaults 0swaps
```

AWS CLI from US to EU
```
export AWS_DEFAULT_REGION=eu-central-1
cat test.tar | pv -a | time aws s3 cp - s3://pxb-test2/test-awscli.tar
[58.8MiB/s]
114.65user 53.05system 8:59.99elapsed 31%CPU (0avgtext+0avgdata 152372maxresident)k
0inputs+0outputs (0major+1195860minor)pagefaults 0swaps
```

## MinIO client
prepare
```
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
./mc config host add s3 https://s3.amazonaws.com AKIAxxx xxx
./mc ls s3/pxb-test
```
MinIO client inside same region
```
cat test.tar | pv -a | time ./mc pipe s3/pxb-test/test-mc.tar
[56.7MiB/s]
21.28user 36.37system 9:13.15elapsed 10%CPU (0avgtext+0avgdata 695176maxresident)k
29488inputs+0outputs (122major+72905minor)pagefaults 0swaps
```

MinIO client from US to EU
```
cat test.tar | pv -a | time ./mc pipe s3/pxb-test2/test-mc.tar
[19.5MiB/s]
22.03user 30.19system 26:54.20elapsed 3%CPU (0avgtext+0avgdata 695360maxresident)k
0inputs+0outputs (0major+73904minor)pagefaults 0swaps
```

## gof3r
prepare
```
snap install go --classic
go get github.com/rlmcpherson/s3gof3r/gof3r
go build -o gof3r github.com/rlmcpherson/s3gof3r/gof3r
```

gof3r inside same region, default settings
```
cat test.tar | pv -a | time ./gof3r put -b pxb-test -k test-gof3r.tar
[96MiB/s]
duration: 5m40.965161034s
206.90user 30.02system 5:40.97elapsed 69%CPU (0avgtext+0avgdata 215092maxresident)k
0inputs+8outputs (0major+52375minor)pagefaults 0swaps
```

gof3r inside same region, tunned
```
cat test.tar | pv -a | time ./gof3r put --concurrency=16 -s 10485802 -b pxb-test -k test-gof3r.tar
[102MiB/s]
duration: 5m20.084233094s
206.93user 30.02system 5:20.09elapsed 74%CPU (0avgtext+0avgdata 308768maxresident)k
128inputs+0outputs (1major+75778minor)pagefaults 0swaps
```

gof3r from US to EU, default settings
```
cat test.tar | pv -a | time ./gof3r put -b pxb-test2 -k test-gof3r.tar --endpoint s3.eu-central-1.amazonaws.com
[93.0MiB/s]
duration: 5m36.526547482s
207.53user 26.63system 5:36.53elapsed 69%CPU (0avgtext+0avgdata 257592maxresident)k
320inputs+0outputs (3major+63001minor)pagefaults 0swaps
```

gof3r from US to EU, tunned
```
cat test.tar | pv -a | time ./gof3r put --concurrency=16 -s 10485802 -b pxb-test2 -k test-gof3r.tar --endpoint s3.eu-central-1.amazonaws.com
[ 104MiB/s]
duration: 5m2.496948208s
207.65user 26.98system 5:02.51elapsed 77%CPU (0avgtext+0avgdata 532272maxresident)k
272inputs+0outputs (2major+132433minor)pagefaults 0swaps
```

## rclone
rclone inside same region
```
curl https://rclone.org/install.sh | sudo bash
rclone config
cat test.tar | pv -a | time rclone rcat s3:pxb-test/test-rclone.tar
[ 136MiB/s]
210.51user 30.72system 3:55.65elapsed 102%CPU (0avgtext+0avgdata 7308932maxresident)k
552inputs+0outputs (5major+525066minor)pagefaults 0swaps
```

rclone from US to EU
```
cat test.tar | pv -a | time rclone rcat s3:pxb-test2/test-rclone.tar
[77MiB/s]
209.12user 26.26system 7:03.91elapsed 55%CPU (0avgtext+0avgdata 9530780maxresident)k
680inputs+0outputs (4major+134500minor)pagefaults 0swaps
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

xbcloud inside same region, default settings
```
xbstream -c test.tar | pv -a | time xbcloud put --storage=s3 --s3-bucket=pxb-test test-xbcloud2.tar
113.47user 30.32system 21:57.99elapsed 10%CPU (0avgtext+0avgdata 98620maxresident)k
2664inputs+0outputs (8major+27008minor)pagefaults 0swaps
```

xbcloud inside same region, 4 threads
```
xbstream -c test.tar | pv -a | time xbcloud put --parallel=4 --storage=s3 --s3-bucket=pxb-test test-xbcloud04.tar
113.62user 32.40system 5:34.74elapsed 43%CPU (0avgtext+0avgdata 171376maxresident)k
0inputs+0outputs (0major+170315minor)pagefaults 0swaps
```

xbcloud inside same region, 8 threads
```
xbstream -c test.tar | pv -a | time xbcloud put --parallel=8 --storage=s3 --s3-bucket=pxb-test test-xbcloud4.tar
113.93user 33.10system 4:05.16elapsed 59%CPU (0avgtext+0avgdata 164340maxresident)k
0inputs+0outputs (0major+866136minor)pagefaults 0swaps
```

xbcloud inside same region, 16 threads
```
xbstream -c test.tar | pv -a | time xbcloud put --parallel=16 --storage=s3 --s3-bucket=pxb-test test-xbcloud3.tar
114.23user 33.26system 4:03.44elapsed 60%CPU (0avgtext+0avgdata 189196maxresident)k
0inputs+0outputs (0major+1096540minor)pagefaults 0swaps
```

xbcloud inside same region, 32 threads
```
xbstream -c test.tar | pv -a | time xbcloud put --parallel=32 --storage=s3 --s3-bucket=pxb-test test-xbcloud.tar
113.09user 33.05system 4:04.34elapsed 59%CPU (0avgtext+0avgdata 199528maxresident)k
0inputs+0outputs (0major+1053214minor)pagefaults 0swaps
```

xbcloud inside same region, 128 threads
```
xbstream -c test.tar | pv -a | time xbcloud put --parallel=128 --storage=s3 --s3-bucket=pxb-test test-xbcloud128.tar
113.56user 32.82system 4:14.85elapsed 57%CPU (0avgtext+0avgdata 156256maxresident)k
0inputs+0outputs (0major+830997minor)pagefaults 0swaps
```

xbloud client from US to EU, default settings
```
xbstream -c test.tar | pv -a | time xbcloud put --storage=s3 --s3-bucket=pxb-test2 test-xbcloud4.tar
113.88user 35.86system 55:35.56elapsed 4%CPU (0avgtext+0avgdata 98464maxresident)k
0inputs+0outputs (0major+27009minor)pagefaults 0swaps
```

xbcloud client from US to EU, 16 threads
```
export AWS_DEFAULT_REGION=eu-central-1
xbstream -c test.tar | pv -a | time xbcloud put --parallel=16 --storage=s3 --s3-bucket=pxb-test2 test-xbcloud16.tar
[ 123MiB/s]
115.16user 41.60system 4:24.45elapsed 59%CPU (0avgtext+0avgdata 426612maxresident)k
0inputs+0outputs (0major+601018minor)pagefaults 0swaps
```



