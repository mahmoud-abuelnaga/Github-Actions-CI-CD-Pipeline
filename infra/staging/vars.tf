variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "public_key" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
