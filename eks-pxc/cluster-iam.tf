# create assume policy for cluster instance role
data "aws_iam_policy_document" "cluster-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# create role for cluster instance
resource "aws_iam_role" "cluster" {
  name               = "${var.cloud_name}-cluster"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.cluster-assume.json}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.cluster.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.cluster.name}"
}
