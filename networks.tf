# VPC networks
resource "yandex_vpc_network" "network" {
  name = "network"
}

# VPC subnets
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
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

# VPC security group
#resource "yandex_vpc_security_group" "private" {
#  name       = "private"
#  network_id = yandex_vpc_network.private.id
#  egress {
#    protocol       = "ANY"
#    description    = "any"
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }
#  ingress {
#    protocol       = "TCP"
#    description    = "ssh"
#    v4_cidr_blocks = ["0.0.0.0/0"]
#    port           = 22
#  }
#}