variable "iam-assume-role-policy" {}

data "aws_iam_policy_document" "policy-document" {
    statement {
        effect = "Allow"
        actions = [
            "s3:*"
        ]

        resources = [
            "${aws_s3_bucket.media-uploads.arn}",
            "${aws_s3_bucket.media-uploads.arn}/*"
        ]
    }
}

resource "aws_iam_role" "container-role" {
    name = "coss-${var.environment}-role"
    assume_role_policy = "${var.iam-assume-role-policy}"
}

resource "aws_iam_role_policy" "iam-role-policy" {
    name   = "coss-${var.environment}-role-policy"
    role   = "${aws_iam_role.container-role.name}"
    policy = "${data.aws_iam_policy_document.policy-document.json}"
}

output "container-role-arn" {
  value = "${aws_iam_role.container-role.arn}"
}
