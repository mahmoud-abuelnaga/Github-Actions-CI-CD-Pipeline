packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "source_ami_name" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}


source "amazon-ebs" "github_actions_ami" {
  ami_name      = "github-actions-ci-cd-pipeline-ami"
  instance_type = var.instance_type
  region        = var.region

  ssh_username = var.ssh_username
  source_ami_filter {
    filters = {
      name                = var.source_ami_name
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["099720109477"] # Canonical
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.github_actions_ami"]

  provisioner "shell" {
    script = "ami_init.sh"
  }
}
