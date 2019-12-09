resource "aws_ecr_repository" "this_ecr" {
  name = var.name

  tags = {
    Name = "${var.project_name}_ecr_repository"
    Terraform = true
    Project = var.name
  }
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  count = length(var.role_names)
  role = var.role_names[count.index]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}


