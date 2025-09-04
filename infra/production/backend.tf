terraform {
  backend "remote" {
    organization = "Github-Actions-CI-CD-Pipeline"

    workspaces {
      name = "production-env"
    }
  }
}
