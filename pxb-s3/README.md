# S3 steaming

we have added s3 streaming feature for PXB in XXX release - link, it was needed for PXC operator - link.
there are two ways to do backups: 1) save on disk and transfer 2) transfer without saving.
Each has pros and cons but if you like second way - upload speed matters, because reduce backup time.
In Percona we are patient about performance, so even in implementation of uploading we try to do our best.
during backup without saving file on the disk we do streaming upload, it is pretty different procedure internally.
intresting fact: chunk size and amount of upload threads matters.
also it is possible to reduce amount of mem if connection was interapted due to failure, xbcloud send data in 10mb chunkks and resend if failure.

# AWS (same region)
from AWS EC2 instance to AWS S3 in us-east-1 region.
small tip: if you run MySQL on EC2 instance to make backups inside one region — do snapshots.

| tool         | settings               | CPU  | max mem | speed    | speed comparison |
| ------------ | ---------------------- | ---- | ------ | -------- | ---------------- |
| aws-cli      | not changeable         |  66% |  149Mb | 130MiB/s | etalon |
| minio client | not changeable         |  10% |  679Mb |  59MiB/s | -55% |
| rclone rcat  | not changeable         | 102% | 7138Mb | 139MiB/s |  +7% |
| gof3r        | default settings       |  69% |  252Mb |  97MiB/s | -25% |
| gof3r        | 10Mb block, 16 threads |  77% |  520Mb | 108MiB/s | -17% |
| xbcloud      | default settings       |  10% |   96Mb |  25MiB/s | -81% |
| xbcloud      | 10Mb block, 16 threads |  60% |  185Mb | 134MiB/s |  +3% |

# AWS (from US to S3)
from AWS EC2 in us-east-1 to AWS S3 in eu-central-1.
It have no sense to make backup to the same region with ec2 instance.

| tool         | settings               | CPU | max mem | speed    | speed comparison |
| ------------ | ---------------------- | --- | ------ | ---------| ---------------- |
| aws-cli      | not changeable         | 31% |  149Mb |  61MiB/s | etalon |
| minio client | not changeable         |  3% |  679Mb |  20MiB/s |  -67% |
| rclone rcat  | not changeable         | 55% | 9307Mb |  77MiB/s |  +26% |
| gof3r        | default settings       | 69% |  252Mb |  97MiB/s |  +59% |
| gof3r        | 10Mb block, 16 threads | 77% |  520Mb | 108MiB/s |  +77% |
| xbcloud      | default settings       |  4% |   96Mb |  10MiB/s |  -84% |
| xbcloud      | 10Mb block, 16 threads | 59% |  417Mb | 123MiB/s | +101% |

# Google Cloud
intresting fact Google Cloud Storage support both native protocol and S3 protocol.
from Compute Engine instance in us-east1 to Cloud Storage europe-west3.

| tool        | settings                            | CPU | max mem | speed    | speed comparison |
| ----------- | ----------------------------------- | --- | ------- | ---------| ---------------- |
| gsutil      | not changeable, native protocol     |  8% |   246Mb |  23MiB/s | etalon |
| rclone rcat | not changeable, native protocol     |  6% |    61Mb |  16MiB/s |  -30% |
| xbcloud     | default settings, s3 protocol       |  3% |    97Mb |   9MiB/s |  -61% |
| xbcloud     | 10Mb block, 16 threads, s3 protocol | 50% |   417Mb | 133MiB/s | +478% |

intresting fact: we calculate md5 sum on fly and put it into `.md5/filename.md5` file, gof3r also do the same.

Please find instructions on GitHub if you like to reproduce this article results - https://github.com/Percona-Lab/k8s-lab/tree/master/pxb-s3.

summary: xbcloud tool is 2-5 times more faster than default realizations with tunned settings on long distance, and 14% faster and requires 20% less memory than analogs with the same settings.
