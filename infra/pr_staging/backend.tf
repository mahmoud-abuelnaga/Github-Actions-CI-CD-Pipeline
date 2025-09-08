terraform {
  backend "remote" {
    organization = "Github-Actions-CI-CD-Pipeline"

    workspaces {
      name = var.workspace_name
    }
  }
}
