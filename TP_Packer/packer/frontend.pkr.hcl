packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "frontend" {
  ami_name    = "frontend-nginx-aws"
  instance_type = "t2.micro"
  region      = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"      
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username  = "ubuntu"
}

build {
  name    = "frontend-build"
  sources = [
    "source.amazon-ebs.frontend"
  ]

  provisioner "shell" {
    inline = [
      # Mise à jour des sources apt
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",

      # Ajout du dépôt universe si nécessaire
      "sudo add-apt-repository universe -y",
      "sudo apt-get update -y",

      # Installation des dépendances
      "sudo apt-get install -y nginx fail2ban",

      # Configuration de l'utilisateur packer
      "sudo useradd -m -s /bin/bash packer",
      "echo 'packer:packer' | sudo chpasswd",
      "echo 'packer ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/packer",

      # Configuration de Nginx
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",

      # Configuration de Fail2Ban
      "sudo systemctl enable fail2ban",
      "sudo systemctl start fail2ban",

      # Nettoyage
      "sudo apt-get clean",
      "sudo rm -rf /var/lib/apt/lists/*"
    ]
  }
}