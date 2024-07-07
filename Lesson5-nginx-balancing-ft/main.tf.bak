terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.zone
  token = var.token_oauth2
  #service_account_key_file = var.svc_acc_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

resource "yandex_compute_disk" "boot-disk" {
  name     = "boot-disk-vm1"
  type     = "network-hdd"
  zone     = var.zone
  size     = "20"
  image_id = var.image_id
}

resource "yandex_compute_instance" "vm-1" {
  name = "web-server"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "cloud-user:${file("~/.ssh/id_ed25519.pub")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "cloud-user"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "file" {
    source      = "ansible"
    destination = "/home/cloud-user"
  }

  provisioner "file" {
    source      = "playbook"
    destination = "/home/cloud-user"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install epel-release && sudo yum -y install sshpass ansible",
      "ssh-keygen -q -t rsa -N '' -f '/home/cloud-user/.ssh/ansibls'",
      "ansible-playbook playbook/install_nginx_rpm.yml -i hosts",
    ]
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network-prime"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-main"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.0/24"]

}


