locals {
  worker-userdata = <<USERDATA
#!/bin/bash -xe

bash -x /etc/eks/bootstrap.sh ${var.cluster-name}
USERDATA
}

resource "aws_launch_configuration" "worker" {
  instance_type = "t2.medium"
  ebs_optimized = false

  name_prefix          = "${var.cluster-name}-worker-"
  image_id             = "${data.aws_ami.worker.id}"
  iam_instance_profile = "${aws_iam_instance_profile.worker.name}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.worker.id}"]
  user_data_base64     = "${base64encode(local.worker-userdata)}"
  spot_price           = 0.02

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  name                 = "${var.cluster-name}-worker"
  desired_capacity     = 3
  launch_configuration = "${aws_launch_configuration.worker.id}"
  max_size             = 3
  min_size             = 2
  vpc_zone_identifier  = ["${module.vpc.public_subnets}"]

  tags = ["${list(
      map("key", "Name", "value", "${var.cluster-name}-worker", "propagate_at_launch", true),
      map("key", "iit-billing-tag", "value", "${var.cluster-name}", "propagate_at_launch", true),
      map("key", "kubernetes.io/cluster/${var.cluster-name}", "value", "owned", "propagate_at_launch", true)
  )}"]
}
