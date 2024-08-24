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
  name     = "boot-disk-web"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_instance" "vm-1" {
  name = "web"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk4.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.10"
    nat       = true
  }

  metadata = {
#    ssh-keys = "cloud-user:${file("~/.ssh/id_ed25519.pub")}"
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "cloud-user"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "file" {
    source = "/home/andrey/.ssh/id_ed25519"
    destination = "/home/cloud-user/.ssh/id_ed25519"
  }
 
  provisioner "file" {
    source = "ansible"
    destination = "/home/cloud-user/ansible"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/cloud-user/.ssh/id_ed25519",
      "echo -e '10.0.0.10	web\n10.0.0.11	postgres-srv1\n10.0.0.12	postgres-srv2\n10.0.0.13	postgres-srv3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname web",
      "sudo cp /home/cloud-user/.ssh/id_ed25519 /home/andrey/.ssh/ && sudo chown andrey:andrey /home/andrey/.ssh/id_ed25519 && sudo chmod 600 /home/andrey/.ssh/id_ed25519",
      "sudo cp -R /home/cloud-user/ansible /home/andrey/ && sudo chown andrey:andrey /home/andrey/ansible",
      "sudo dnf install epel-release -y && sudo  dnf install ansible -y",
      "sudo -u andrey bash -c 'cd /home/andrey/ansible && ansible-playbook playbooks/deploy.yml'",
    ]
  }
  depends_on = [
    yandex_compute_instance.vm-2,
    yandex_compute_instance.vm-3,
    yandex_compute_instance.vm-4
  ]
}

resource "yandex_compute_instance" "vm-2" {
  name = "postgres-srv1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.11"
    nat = true
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"   
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "cloud-user"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo  '10.0.0.10	web\n10.0.0.11	postgres-srv1\n10.0.0.12	postgres-srv2\n10.0.0.13	postgres-srv3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname postgres-srv1",
    ]
  }
}

resource "yandex_compute_instance" "vm-3" {
  name = "postgres-srv2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.12"
    nat = true
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "cloud-user"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo  '10.0.0.10	web\n10.0.0.11	postgres-srv1\n10.0.0.12	postgres-srv2\n10.0.0.13	postgres-srv3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname postgres-srv2",
    ]
  }
}

resource "yandex_compute_instance" "vm-4" {
  name = "postgres-srv3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk3.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.13"
    nat = true
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "cloud-user"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
  }

  provisioner "remote-exec" {
    inline = [
      "echo  '10.0.0.10	web\n10.0.0.11	postgres-srv1\n10.0.0.12	postgres-srv2\n10.0.0.13	postgres-srv3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname postgres-srv3",
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


