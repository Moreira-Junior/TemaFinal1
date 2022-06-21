packer {
  required_plugins {
    docker = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "repo" {
  type    = string
}

variable "user"{
  type = string
}

variable "pass"{
  type = string
}

source "docker" "ubuntu" {
  image  = "ubuntu:focal"
  commit = true
    changes = [
      "EXPOSE 8080",
      "ENTRYPOINT /opt/apache-tomcat-9.0.62/bin/catalina.sh run"
    ]
}

build {
  name    = "job2"
  sources = [
    "source.docker.ubuntu"
  ]
  provisioner "shell"{
    inline = [
      "apt-get update", 
      "apt-get install ansible -y"
    ]
  }
  provisioner "ansible-local" {
    playbook_file = "./job2/playbook.yml"
  }
  provisioner "file" {
    source = "./calculator.war"
    destination = "/opt/apache-tomcat-9.0.62/webapps/calculator.war"
  } 
  post-processors {
    post-processor "docker-tag" {
      repository = var.repo
      tags        = ["job2"]
  }
    post-processor "docker-push" {
      login = true
      login_username = var.user
      login_password = var.pass
    }
  }
}

