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
  name     = "boot-disk-loadbalancer"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk2" {
  name     = "web1"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk3" {
  name     = "web2"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk4" {
  name     = "consul1"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk5" {
  name     = "consul2"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_disk" "boot-disk6" {
  name     = "consul3"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
}

resource "yandex_compute_instance" "vm-1" {
  name = "loadbalancer"

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

  provisioner "remote-exec" {
    inline = [
      "echo -e '10.0.0.10	web web.service.consul	loadbalancer\n10.0.0.4	web1\n10.0.0.5	web2\n10.0.0.6	consul1\n10.0.0.7	consul2\n10.0.0.8	consul3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname loadbalancer",
    ]
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "web1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.4"
    nat = true
  }

  metadata = {
    user-data = "${file("cloud-init.yml")}"   
  }

  provisioner "file" {
    source = "/home/andrey/.ssh/id_ed25519"
    destination = "/home/cloud-user/.ssh/id_ed25519"
  }

  provisioner "file" {
    source = "ansible"
    destination = "/home/cloud-user/ansible"
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
     "chmod 600 /home/cloud-user/.ssh/id_ed25519",
      "sudo cp /home/cloud-user/.ssh/id_ed25519 /home/andrey/.ssh/ && sudo chown andrey:andrey /home/andrey/.ssh/id_ed25519 && sudo chmod 600 /home/andrey/.ssh/id_ed25519",
      "sudo cp -R /home/cloud-user/ansible /home/andrey/ && sudo chown andrey:andrey /home/andrey/ansible",
      "sudo dnf install epel-release -y && sudo dnf install ansible -y",
      "echo -e '10.0.0.10       web web.service.consul	loadbalancer\n10.0.0.4        web1\n10.0.0.5  web2\n10.0.0.6  consul1\n10.0.0.7       consul2\n10.0.0.8       consul3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname web1",
    ]
  }
  depends_on = [
    yandex_compute_instance.vm-2,
    yandex_compute_instance.vm-3,
    yandex_compute_instance.vm-4,
    yandex_compute_instance.vm-6
  ]
}

resource "yandex_compute_instance" "vm-3" {
  name = "web2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk3.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.5"
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
      "echo -e '10.0.0.10       web web.service.consul	loadbalancer\n10.0.0.4        web1\n10.0.0.5  web2\n10.0.0.6  consul1\n10.0.0.7       consul2\n10.0.0.8       consul3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname web2",
    ]
  }
}

resource "yandex_compute_instance" "vm-4" {
  name = "consul1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk4.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.6"
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
      "echo -e '10.0.0.10       web web.service.consul	loadbalancer\n10.0.0.4        web1\n10.0.0.5  web2\n10.0.0.6  consul1\n10.0.0.7       consul2\n10.0.0.8       consul3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname consul1",
    ]
  }
}

resource "yandex_compute_instance" "vm-5" {
  name = "consul2"

  resources {
    cores  = 2
    memory = 6
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk5.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.7"
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
      "echo -e '10.0.0.10       web web.service.consul  loadbalancer\n10.0.0.4        web1\n10.0.0.5  web2\n10.0.0.6  consul1\n10.0.0.7       consul2\n10.0.0.8       consul3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname consul2",
    ]
  }
}

resource "yandex_compute_instance" "vm-6" {
  name = "consul3"

  resources {
    cores  = 2
    memory = 6
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk6.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = "10.0.0.8"
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
      "echo -e '10.0.0.10       web web.service.consul  loadbalancer\n10.0.0.4        web1\n10.0.0.5  web2\n10.0.0.6  consul1\n10.0.0.7       consul2\n10.0.0.8       consul3' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname consul3",
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


