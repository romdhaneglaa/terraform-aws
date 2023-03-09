resource "aws_iam_policy" "main" {
  name = "${var.env_code}s3_access"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": "*"
      }
    ]
  })



}

resource "aws_iam_role" "main" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  name = "${var.env_code}"
}

resource "aws_iam_role_policy_attachment" "main" {
  policy_arn         = aws_iam_policy.main.arn
  role               = aws_iam_role.main.name
}

resource "aws_iam_instance_profile" "main" {
  name = var.env_code
  role = aws_iam_role.main.name

}