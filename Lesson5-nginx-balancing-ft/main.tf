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
  name     = "boot-disk-bl"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk2" {
  name     = "boot-disk-app1"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk3" {
  name     = "boot-disk-app2"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk4" {
  name     = "boot-disk-db"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_instance" "vm-1" {
  name = "balancer"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.10"
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
    source = "/home/andrey/.ssh/id_ed25519"
    destination = "/home/cloud-user/.ssh/id_ed25519"
  }
  
  provisioner "file" {
    source = "/home/andrey/.ssh/id_ed25519.pub"
    destination = "/home/cloud-user/.ssh/id_ed25519.pub"
  }

  provisioner "file" {
    source = "ansible.cfg"
    destination = "/home/cloud-user/ansible.cfg"
  }

  provisioner "file" {
    source = "inventory"
    destination = "/home/cloud-user/inventory"
  }

  provisioner "file" {
    source = "roles"
    destination = "/home/cloud-user/roles"
  }

  provisioner "file" {
    source = "deploy.yml"
    destination = "/home/cloud-user/deploy.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/cloud-user/.ssh/id_ed25519",
      "echo -e '10.0.0.10	balancer\n10.0.0.11	app-1\n10.0.0.12	app-2\n10.0.0.20	database' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname balancer",
      "sudo dnf install epel-release -y && sudo  dnf install ansible -y",
      "cd /home/cloud-user/ && ansible-playbook deploy.yml",
    ]
  }
  depends_on = [ 
    yandex_compute_instance.vm-2, 
    yandex_compute_instance.vm-3, 
    yandex_compute_instance.vm-4
  ]
}

resource "yandex_compute_instance" "vm-2" {
  name = "app-1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.11"
    nat = true
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

  provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.10       balancer\n10.0.0.11     app-1\n10.0.0.12        app-2\n10.0.0.20        database' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname app-1",
    ]
  }  
}

resource "yandex_compute_instance" "vm-3" {
  name = "app-2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk3.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.12"
    nat = true
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

  provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.10       balancer\n10.0.0.11     app-1\n10.0.0.12        app-2\n10.0.0.20        database' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname app-2",
    ]
  }
}

resource "yandex_compute_instance" "vm-4" {
  name = "database"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk4.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.20"
    nat = true
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

  provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.10       balancer\n10.0.0.11     app-1\n10.0.0.12        app-2\n10.0.0.20        database' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname database",
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


