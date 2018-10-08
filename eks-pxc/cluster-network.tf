module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.cluster-name}"
  cidr                 = "192.168.192.0/22"
  azs                  = ["${var.aws_region}b", "${var.aws_region}c", "${var.aws_region}d"]
  public_subnets       = ["192.168.192.0/24", "192.168.193.0/24", "192.168.194.0/24"]
  enable_dns_hostnames = true

  tags = "${map(
    "Name", "${var.cluster-name}",
    "iit-billing-tag", "${var.cluster-name}",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )}"
}

resource "aws_security_group" "cluster" {
  name        = "${var.cluster-name}-cluster"
  description = "EKS Cluster communication"
  vpc_id      = "${module.vpc.vpc_id}"

  tags = "${map(
    "Name", "${var.cluster-name}-cluster",
    "iit-billing-tag", "${var.cluster-name}",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )}"
}

resource "aws_security_group_rule" "cluster-egress-worker-api" {
  security_group_id        = "${aws_security_group.cluster.id}"
  description              = "Allow cluster to communication with workers"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.worker.id}"
  type                     = "egress"
}

resource "aws_security_group_rule" "cluster-egress-worker" {
  security_group_id        = "${aws_security_group.cluster.id}"
  description              = "Allow cluster to communication with workers"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.worker.id}"
  type                     = "egress"
}

resource "aws_security_group_rule" "cluster-ingress-worker-https" {
  security_group_id        = "${aws_security_group.cluster.id}"
  description              = "Allow workers to communicate with the cluster API Server"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.worker.id}"
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  security_group_id = "${aws_security_group.cluster.id}"
  description       = "Allow administrator to communicate with the cluster API Server"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["176.37.55.60/32", "178.214.201.190/32"]
}
