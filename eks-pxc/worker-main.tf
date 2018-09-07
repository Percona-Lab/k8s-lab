locals {
  worker-userdata = <<USERDATA
#!/bin/bash -xe

bash -x /etc/eks/bootstrap.sh ${var.cluster-name} --kubelet-extra-args --node-labels=lifecycle=Ec2Spot
USERDATA
}

resource "aws_spot_fleet_request" "worker" {
  allocation_strategy                 = "diversified"
  excess_capacity_termination_policy  = "Default"
  iam_fleet_role                      = "${aws_iam_role.worker-fleet.arn}"
  replace_unhealthy_instances         = "true"
  spot_price                          = "0.02"
  target_capacity                     = 3
  terminate_instances_with_expiration = "false"
  fleet_type                          = "maintain"
  valid_until                         = "2099-09-01T00:00:00Z"

  launch_specification {
    instance_type = "t2.medium"
    ebs_optimized = "false"

    ami                         = "${data.aws_ami.worker.id}"
    subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
    vpc_security_group_ids      = ["${aws_security_group.worker.id}"]
    iam_instance_profile_arn    = "${aws_iam_instance_profile.worker.arn}"
    key_name                    = "${var.key_name}"
    monitoring                  = "false"
    user_data                   = "${base64encode(local.worker-userdata)}"
    associate_public_ip_address = "true"

    tags = "${
      map(
        "Name", "${var.cluster-name}-worker",
        "iit-billing-tag", "${var.cluster-name}",
        "kubernetes.io/cluster/${var.cluster-name}", "shared",
      )
    }"
  }

  launch_specification {
    instance_type = "t2.medium"
    ebs_optimized = "false"

    ami                         = "${data.aws_ami.worker.id}"
    subnet_id                   = "${element(module.vpc.public_subnets, 1)}"
    vpc_security_group_ids      = ["${aws_security_group.worker.id}"]
    iam_instance_profile_arn    = "${aws_iam_instance_profile.worker.arn}"
    key_name                    = "${var.key_name}"
    monitoring                  = "false"
    user_data                   = "${base64encode(local.worker-userdata)}"
    associate_public_ip_address = "true"

    tags = "${
      map(
        "Name", "${var.cluster-name}-worker",
        "iit-billing-tag", "${var.cluster-name}",
        "kubernetes.io/cluster/${var.cluster-name}", "shared",
      )
    }"
  }

  launch_specification {
    instance_type = "t2.medium"
    ebs_optimized = "false"

    ami                         = "${data.aws_ami.worker.id}"
    subnet_id                   = "${element(module.vpc.public_subnets, 2)}"
    vpc_security_group_ids      = ["${aws_security_group.worker.id}"]
    iam_instance_profile_arn    = "${aws_iam_instance_profile.worker.arn}"
    key_name                    = "${var.key_name}"
    monitoring                  = "false"
    user_data                   = "${base64encode(local.worker-userdata)}"
    associate_public_ip_address = "true"

    tags = "${
      map(
        "Name", "${var.cluster-name}-worker",
        "iit-billing-tag", "${var.cluster-name}",
        "kubernetes.io/cluster/${var.cluster-name}", "shared",
      )
    }"
  }
}
