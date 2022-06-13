packer {
  required_plugins {
    docker = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:xenial"
  commit = true
}

build {
  name    = "job2"
  sources = [
    "source.docker.ubuntu"
  ]
  provisioner "ansible" {
    playbook_file = "job2/playbook.yml"
  }
  post-processor "docker-tag" {
    repository = "juniormoreira88/job2"
    tags       = ["job2"]
    only       = ["docker.ubuntu"]
  }
  post-processor "docker-push" {
    login=true
    login_username = "junior_moreira88@hotmail.com"
    login_password = "Teste1234"
  }
}

