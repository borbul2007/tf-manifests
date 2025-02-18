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