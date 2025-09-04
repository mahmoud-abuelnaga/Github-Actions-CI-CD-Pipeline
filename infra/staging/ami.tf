data "aws_ami" "staging_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["github-actions-ci-cd-pipeline-ami"]
  }

  owners = ["self"]
}
