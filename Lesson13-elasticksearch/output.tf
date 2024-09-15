output "ip_address_web" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "ip_address_opensearch" {
  value = yandex_compute_instance.vm-5.network_interface.0.nat_ip_address
}
