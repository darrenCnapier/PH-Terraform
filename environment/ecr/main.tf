resource "aws_ecr_repository" "this_ecr" {
  name = var.name

  tags = {
    Name = "${var.project_name}_ecr_repository"
    Terraform = true
    Project = var.name
  }
}



