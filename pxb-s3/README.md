# S3 streaming tools comparison

Making backups over the network can be done in two ways: either save on disk and transfer or just transfer without saving.
Both ways have their strong and weak points. Particularly, the second way is highly dependent on the upload speed, which would either reduce or increase the backup time. Other factors that influence it are chunk size and amount of upload threads.

Starting from the [2.4.14 release](https://www.percona.com/blog/2019/05/01/percona-xtrabackup-2-4-14-is-now-available/), Percona XtraBackup got the capability of such backup upload on s3-compatible storage without saving – an s3 streaming. This feature was developed because we wanted to improve the upload speeds of backups in [Percona Operator for XtraDB Cluster](https://www.percona.com/software/percona-kubernetes-operators).

There are many realizations of S3 Compatible Storage: AWS S3, [Google Cloud Storage](interoperability), [Digital Ocean Spaces](https://www.digitalocean.com/products/spaces/), [Alibaba Cloud OSS](https://www.alibabacloud.com/help/doc-detail/64919.htm), [MinIO](https://min.io), [Wasabi](https://wasabi.com).

We have made the speed comparison of [AWS CLI](https://aws.amazon.com/cli/), [gsutil](https://cloud.google.com/storage/docs/gsutil), [MinIO client](https://docs.min.io/docs/minio-client-complete-guide), [rclone](https://rclone.org), [gof3r](https://github.com/rlmcpherson/s3gof3r) and Percona [xbcloud](https://www.percona.com/doc/percona-xtrabackup/LATEST/xbcloud/xbcloud.html) tool with AWS (in single and multi-region setups) and Google Cloud destinations. The XtraBackup was compared in two variants: a default configuration and one with tuned chunk size and amount of uploading threads.

Here are the results.

# AWS (same region)
The backup data were streamed from the AWS EC2 instance to the AWS S3, both in the us-east-1 region.

| tool         | settings               | CPU  | max mem | speed    | speed comparison |
| ------------ | ---------------------- | ---- | ------ | -------- | ---------------- |
| AWS CLI      | not changeable         |  66% |  149Mb | 130MiB/s | etalon |
| MinIO client | not changeable         |  10% |  679Mb |  59MiB/s | -55% |
| rclone rcat  | not changeable         | 102% | 7138Mb | 139MiB/s |  +7% |
| gof3r        | default settings       |  69% |  252Mb |  97MiB/s | -25% |
| gof3r        | 10Mb block, 16 threads |  77% |  520Mb | 108MiB/s | -17% |
| xbcloud      | default settings       |  10% |   96Mb |  25MiB/s | -81% |
| xbcloud      | 10Mb block, 16 threads |  60% |  185Mb | 134MiB/s |  +3% |

small tip: if you run MySQL on EC2 instance to make backups inside one region — do snapshots instead.

# AWS (from US to EU)
The backup data were streamed from AWS EC2 in us-east-1 to AWS S3 in eu-central-1.

| tool         | settings               | CPU | max mem | speed    | speed comparison |
| ------------ | ---------------------- | --- | ------ | ---------| ---------------- |
| AWS CLI      | not changeable         | 31% |  149Mb |  61MiB/s | etalon |
| MinIO client | not changeable         |  3% |  679Mb |  20MiB/s |  -67% |
| rclone rcat  | not changeable         | 55% | 9307Mb |  77MiB/s |  +26% |
| gof3r        | default settings       | 69% |  252Mb |  97MiB/s |  +59% |
| gof3r        | 10Mb block, 16 threads | 77% |  520Mb | 108MiB/s |  +77% |
| xbcloud      | default settings       |  4% |   96Mb |  10MiB/s |  -84% |
| xbcloud      | 10Mb block, 16 threads | 59% |  417Mb | 123MiB/s | +101% |

Small tip: Think about disaster recovery, what will you do when the whole region is not available, it makes no sense to back up to the same region, always transfer backups to another region.

# Google Cloud (from US to EU)
The backup data were streamed from Compute Engine instance in us-east1 to Cloud Storage europe-west3.
Interestingly, Google Cloud Storage supports both native protocol and [S3(interoperability) API](https://cloud.google.com/storage/docs/interoperability).
So, Percona XtraBackup can transfer data to Google Cloud Storage directly via S3(interoperability) API.

| tool        | settings                            | CPU | max mem | speed    | speed comparison |
| ----------- | ----------------------------------- | --- | ------- | ---------| ---------------- |
| gsutil      | not changeable, native protocol     |  8% |   246Mb |  23MiB/s | etalon |
| rclone rcat | not changeable, native protocol     |  6% |    61Mb |  16MiB/s |  -30% |
| xbcloud     | default settings, s3 protocol       |  3% |    97Mb |   9MiB/s |  -61% |
| xbcloud     | 10Mb block, 16 threads, s3 protocol | 50% |   417Mb | 133MiB/s | +478% |

Small tip: Cloud provider can block your account due to many reasons, like human or robot mistakes, inappropriate content abuse after hacking, credit card expire, sanctions, etc. Think about disaster recovery, what will you do when cloud provider blocked your account, it can have the sense to back up to another cloud provider or on-premise.

# Conclusion
Percona XtraBackup is 2-5 times faster when default realizations with tuned settings on long distance, and 14% faster and requires 20% less memory than analogs with the same settings.
Percona XtraBackup is the most reliable tool for transfer backups because of two reasons:

* it calculate md5 sum on fly and put it into `.md5/filename.md5` file and verify sums on recovery (gof3r does the same)
* xbcloud send data in 10mb chunks and resend them if any network failure happens.

PS: Please find [instructions on GitHub](https://github.com/Percona-Lab/k8s-lab/tree/master/pxb-s3) if you like to reproduce this article results.
