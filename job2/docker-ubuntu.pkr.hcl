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
  post-processors {
    post-processor "docker-import" {
      repository = "juniormoreira88/job2
      tag        = "job2"
  }
    post-processor "docker-push" {}
  }
}

