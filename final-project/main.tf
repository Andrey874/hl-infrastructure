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

resource "yandex_compute_disk" "secondary_disk" {
  name     = "storage"
  type     = "network-hdd"
  zone     = var.zone
  size     = 5
}

resource "yandex_compute_disk" "boot-disk1" {
  name     = "boot-disk-pg1"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_deb
}

resource "yandex_compute_disk" "boot-disk2" {
  name     = "boot-disk-pg2"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_deb
}

resource "yandex_compute_disk" "boot-disk3" {
  name     = "boot-disk-pg3"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_deb
}

resource "yandex_compute_disk" "boot-disk4" {
  name     = "boot-disk-web1"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk5" {
  name     = "boot-disk-web2"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk6" {
  name     = "boot-disk-web3"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk7" {
  name     = "boot-disk-storage"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk8" {
  name     = "boot-disk-loadbalancer1"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk9" {
  name     = "boot-disk-loadbalancer2"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk10" {
  name     = "boot-disk-desktop"
  type     = "network-hdd"
  zone     = var.zone
  size     = "20"
  image_id = var.image_sus_open
}

resource "yandex_compute_instance" "vm-1" {
  name = "loadbalancer1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk8.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-external.id
    ip_address = "172.16.0.3"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.front-back.id
    ip_address = "10.0.0.3"
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.3	loadbalancer1\n10.0.0.4	loadbalancer2\n10.0.0.10	web1\n10.0.0.11	web2\n10.0.0.12	web3\n10.0.0.13	storage' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname loadbalancer1",
    ]
  }

}

resource "yandex_compute_instance" "vm-2" {
  name = "loadbalancer2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk9.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-external.id
    ip_address = "172.16.0.4"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.front-back.id
    ip_address = "10.0.0.4"
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

   provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.3        loadbalancer1\n10.0.0.4 loadbalancer2\n10.0.0.10        web1\n10.0.0.11 web2\n10.0.0.12 web3\n10.0.0.13 storage' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname loadbalancer2",
    ]
  }

}

resource "yandex_compute_instance" "vm-3" {
  name = "web1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk4.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.front-back.id
    ip_address = "10.0.0.10"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-corosync.id
    ip_address = "10.0.0.19"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-iscsi.id
    ip_address = "10.0.0.51"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.back-cdb.id
    ip_address = "10.0.0.41"
  }
  
  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "file" {
    source = "/home/andrey/.ssh/id_ed25519"
    destination = "/home/andrey/.ssh/id_ed25519"
  }

  provisioner "file" {
    source = "ansible"
    destination = "/home/andrey/ansible"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/andrey/.ssh/id_ed25519",
      "echo -e '10.0.0.3	loadbalancer1\n10.0.0.4	loadbalancer2\n10.0.0.19	web1\n10.0.0.20	web2\n10.0.0.21	web3\n10.0.0.13	storage\n10.0.0.35	pg1\n10.0.0.36	pg2\n10.0.0.37	pg3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname web1",
      "sudo dnf install epel-release -y && sudo  dnf install ansible -y",
    ]
  }

}

resource "yandex_compute_instance" "vm-4" {
  name = "web2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk5.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.front-back.id
    ip_address = "10.0.0.11"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-corosync.id
    ip_address = "10.0.0.20"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-iscsi.id
    ip_address = "10.0.0.52"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.back-cdb.id
    ip_address = "10.0.0.42"
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.3	loadbalancer1\n10.0.0.4	loadbalancer2\n10.0.0.19	web1\n10.0.0.20	web2\n10.0.0.21	web3\n10.0.0.13	storage\n10.0.0.35	pg1\n10.0.0.36	pg2\n10.0.0.37	pg3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname web2",
    ]
  }
}

resource "yandex_compute_instance" "vm-5" {
  name = "web3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk6.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.front-back.id
    ip_address = "10.0.0.12"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-corosync.id
    ip_address = "10.0.0.21"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-iscsi.id
    ip_address = "10.0.0.53"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.back-cdb.id
    ip_address = "10.0.0.43"
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.3	loadbalancer1\n10.0.0.4	loadbalancer2\n10.0.0.19	web1\n10.0.0.20	web2\n10.0.0.21	web3\n10.0.0.13	storage\n10.0.0.35	pg1\n10.0.0.36	pg2\n10.0.0.37	pg3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname web3",
    ]
  }
}

resource "yandex_compute_instance" "vm-6" {
  name = "storage"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk7.id
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.secondary_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.front-back.id
    ip_address = "10.0.0.13"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-iscsi.id
    ip_address = "10.0.0.60"
  }
  
  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname storage",
    ]
  }
}

resource "yandex_compute_instance" "vm-7" {
  name = "pg1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.back-cdb.id
    ip_address = "10.0.0.35"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-cdb.id
    ip_address = "10.0.0.71"
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo  '10.0.0.35	pg1\n10.0.0.36	pg2\n10.0.0.37	pg3\n10.0.0.41	web1\n10.0.0.42	web2\n10.0.0.43	web3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname pg1",
    ]
  }
}

resource "yandex_compute_instance" "vm-8" {
  name = "pg2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.back-cdb.id
    ip_address = "10.0.0.36"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-cdb.id
    ip_address = "10.0.0.72"
  }

  
  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo  '10.0.0.35	pg1\n10.0.0.36	pg2\n10.0.0.37	pg3\n10.0.0.41	web1\n10.0.0.42	web2\n10.0.0.43	web3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname pg2",
    ]
  }
}

resource "yandex_compute_instance" "vm-9" {
  name = "pg3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk3.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.back-cdb.id
    ip_address = "10.0.0.37"
    nat = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-cdb.id
    ip_address = "10.0.0.73"
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo  '10.0.0.35	pg1\n10.0.0.36	pg2\n10.0.0.37	pg3\n10.0.0.41	web1\n10.0.0.42	web2\n10.0.0.43	web3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname pg3",
    ]
  }
}

resource "yandex_compute_instance" "vm-10" {
  name = "desktop"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk10.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-external.id
    ip_address = "172.16.0.10"
    nat = true
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "andrey"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo  '172.16.0.5	web-app' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname desktop",
      "sudo useradd -p 123321ab -s /bin/bash user1",
#      "sudo zypper install -t pattern kde kde_plasma",
#      "sudo zypper install mozilla* xrdp",
    ]
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network-prime"
}

resource "yandex_vpc_subnet" "subnet-external" {
  name           = "subnet-external"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["172.16.0.0/28"]
}

resource "yandex_vpc_subnet" "front-back" {
  name           = "front-back"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.0/28"]
}

resource "yandex_vpc_subnet" "back-cdb" {
  name           = "back-cdb"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.32/28"]
}

resource "yandex_vpc_subnet" "subnet-iscsi" {
  name           = "subnet-iscsi"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.48/28"]
}

resource "yandex_vpc_subnet" "subnet-corosync" {
  name           = "subnet-corosync"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.16/28"]
}

resource "yandex_vpc_subnet" "subnet-cdb" {
  name           = "subnet-cdb"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.64/28"]
}
