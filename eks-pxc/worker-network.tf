resource "aws_security_group" "worker" {
  name        = "${var.cloud_name}-worker"
  description = "EKS worker communication"
  vpc_id      = "${module.vpc.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name                                      = "${var.cloud_name}"
    iit-billing-tag                           = "${var.cloud_name}"
    "kubernetes.io/cluster/${var.cloud_name}" = "owned"
  }
}

resource "aws_security_group_rule" "worker-ingress-self" {
  security_group_id        = "${aws_security_group.worker.id}"
  description              = "Allow workers to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.worker.id}"
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-ingress-cluster" {
  security_group_id        = "${aws_security_group.worker.id}"
  description              = "Allow worker to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.cluster.id}"
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-ingress-admin" {
  security_group_id = "${aws_security_group.worker.id}"
  description       = "Allow administrator to communicate with the workers"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["176.37.55.60/32", "178.214.201.190/32"]
}
