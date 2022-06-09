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
    environment_vars = [
      "FOO=hello world",
    ]
  }

  post-processor "docker-tag" {
    repository = "job2"
    tags       = ["ubuntu-xenial"]
    only       = ["docker.ubuntu"]
  }
}
