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
  default = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "resulting_ami_name" {
  type    = string
  default = "github-actions-ci-cd-pipeline-ami"
}

source "amazon-ebs" "github_actions_ami" {
  ami_name      = var.resulting_ami_name
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

locals {
  timestamp = formatdate("2006-01-02-15-04-05", timestamp())
}

build {
  sources = ["source.amazon-ebs.github_actions_ami"]

  provisioner "shell" {
    script = "ami_init.sh"
  }

  post-processor "manifest" {
    output = "manifest-${local.timestamp}.json"
  }

  post-processor "shell-local" {
    inline = [
      "cat manifest-${local.timestamp}.json | jq '.builds[0].artifact_id' | cut -d '\"' -f 2 | cut -d ':' -f 2 | tee ami_id.txt"
    ]
  }
}
