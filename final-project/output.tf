output "ip_address_web1" {
  value = yandex_compute_instance.vm-3.network_interface.0.nat_ip_address
}

output "ip_address_desktop" {
  value = yandex_compute_instance.vm-10.network_interface.0.nat_ip_address
}
