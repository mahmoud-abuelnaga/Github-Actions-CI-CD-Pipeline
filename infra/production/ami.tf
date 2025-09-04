data "aws_ami" "prod_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["github-actions-ci-cd-pipeline-ami"]
  }

  owners = ["self"]
}
