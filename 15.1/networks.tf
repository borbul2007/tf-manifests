# VPC networks
resource "yandex_vpc_network" "network" {
  name = "network"
}

# VPC subnets
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.public_yandex_vpc_subnet_default_cidr
}
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.private_yandex_vpc_subnet_default_cidr
  route_table_id = yandex_vpc_route_table.nat.id
}

# VPC route table
resource "yandex_vpc_route_table" "nat" {
  name       = "nat"
  network_id = yandex_vpc_network.network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}
