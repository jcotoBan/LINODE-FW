terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.token
  api_version = "v4beta"
}

#Linode VM specs, you can change the type (plan)/region/labels
resource "linode_instance" "lvm"{
label = "lvm"
image = "linode/debian11"
region = "us-southeast"
type = "g6-nanode-1"
root_pass = var.root_pass
private_ip = true
authorized_keys = [linode_sshkey.my_own_key.ssh_key]

  provisioner "file"{
    source = "./server.sh"
    destination = "/tmp/server.sh"
    connection {
      type = "ssh"
      host = self.ip_address
      user = "root"
      password = var.root_pass
    }
  }

  provisioner "remote-exec"{
    inline = [
      "source ~/.bashrc",
      "chmod +x /tmp/server.sh",
      "/tmp/server.sh",
      "sleep 1"
    ]
    connection {
      type = "ssh"
      host = self.ip_address
      user = "root"
      password = var.root_pass
    }

  }

}

resource "linode_sshkey" "my_own_key" {
  label = "my_own_key"
  ssh_key = chomp(file("./ssh-keys/mykey.pub"))
}


resource "linode_firewall" "my_firewall" {
  label = "fwvm"

  inbound {
    label            = "Accept-SSH"
    protocol         = "TCP"
    action           = "ACCEPT"
    ipv4             = ["0.0.0.0/0"]
    ports            = "22"
  }
  
  #Drop all by default
  outbound_policy = "DROP"
  inbound_policy = "DROP"

  linodes = [linode_instance.lvm.id]
}


variable "token"{}
variable "root_pass"{}