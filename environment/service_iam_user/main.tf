resource "aws_iam_user" "this_user" {
  name = var.username
  tags = {
    Name = "${var.name}_iam_user"
    Terraform = true
    Project = var.name
  }
}

resource "aws_iam_access_key" "this_user_access_keys" {
  user = aws_iam_user.this_user.name
}

resource "aws_iam_user_policy_attachment" "ecr_policy" {
  user = aws_iam_user.this_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_user_policy_attachment" "ssm_policy" {
  user = aws_iam_user.this_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
