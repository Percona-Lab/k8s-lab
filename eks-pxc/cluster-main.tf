resource "aws_eks_cluster" "eks" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.cluster.arn}"

  vpc_config {
    subnet_ids         = ["${module.vpc.public_subnets}"]
    security_group_ids = ["${aws_security_group.cluster.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.AmazonEKSServicePolicy",
    "aws_iam_role_policy_attachment.AmazonEKSServicePolicy",
  ]
}
