packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
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
  provisioner "shell" {
  inline  = [
    "apt-get install sudo"
  ]
  only = ["docker"]
  }
  post-processors {
    post-processor "docker-tag" {
      tags        = ["ubuntu"]
    }
  }
}

