resource "aws_key_pair" "staging" {
  key_name   = "github-actions-proj-staging-key"
  public_key = var.public_key
}

resource "aws_security_group" "staging" {
  name        = "github-actions-proj-staging-sg"
  description = "Security group for staging environment"
  vpc_id      = data.aws_vpc.ec2_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "staging_instance" {
  ami                         = data.aws_ami.staging_ami.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.staging.key_name
  vpc_security_group_ids      = [aws_security_group.staging.id]
  associate_public_ip_address = true

  tags = {
    Name = "github-actions-staging-instance"
  }

}
