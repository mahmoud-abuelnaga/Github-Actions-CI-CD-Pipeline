resource "aws_key_pair" "ec2" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_security_group" "ec2" {
  name        = var.sg_name
  description = var.sg_description
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

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ami.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ec2.key_name
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }

}
