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
    changes = [
      "EXPOSE 8080",
      "ENTRYPOINT /home/tomcat9/bin/catalina.sh run"
    ]
}

build {
  name    = "job2"
  sources = [
    "source.docker.ubuntu"
  ]
  provisioner "ansible" {
    playbook_file = "job2/playbook.yml"
  }
  provisioner "file" {
    source = "calculator.war"
    destination = "/home/tomcat9/webapps/calculator.war"
  } 
  post-processors {
    post-processor "docker-tag" {
      repository = "juniormoreira88/job2"
      tags        = ["job2"]
  }
    post-processor "docker-push" {
      login = true
      login_username = "juniormoreira88"
      login_password = "Teste1234"
    }
  }
}

