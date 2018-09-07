# create policy for worker spot fleet role
data "aws_iam_policy_document" "worker-fleet-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["spotfleet.amazonaws.com"]
    }
  }
}

# create role for worker spot fleet
resource "aws_iam_role" "worker-fleet" {
  name               = "${var.cluster-name}-worker-fleet"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.worker-fleet-assume.json}"
}

# attach managed policy for worker spot fleet role
resource "aws_iam_role_policy_attachment" "AmazonEC2SpotFleetTaggingRole" {
  role       = "${aws_iam_role.worker-fleet.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
}
