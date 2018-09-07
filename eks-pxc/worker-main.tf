locals {
  worker-userdata = <<USERDATA
#!/bin/bash -xe

/etc/eks/bootstrap.sh ${var.cluster-name}
USERDATA
}

resource "aws_launch_configuration" "worker" {
  name_prefix          = "${var.cluster-name}-worker"
  iam_instance_profile = "${aws_iam_instance_profile.worker.name}"
  image_id             = "${data.aws_ami.worker.id}"
  instance_type        = "t2.medium"
  security_groups      = ["${aws_security_group.worker.id}"]
  user_data_base64     = "${base64encode(local.worker-userdata)}"
  key_name             = "${var.key_name}"

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

  tag {
    key                 = "Name"
    value               = "${var.cluster-name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "iit-billing-tag"
    value               = "${var.cluster-name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
