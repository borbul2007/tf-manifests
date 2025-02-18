output "instance_group__external_ip" {
  value = data.yandex_compute_instance_group.instance_group.instances.*.network_interface.0.nat_ip_address
}
