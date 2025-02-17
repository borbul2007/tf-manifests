# VPC networks
resource "yandex_vpc_network" "public" {}
resource "yandex_vpc_network" "private" {
  name = "private"
}

# VPC subnets
resource "yandex_vpc_subnet" "public" {
  name           = "public-ru-central1-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.public.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
resource "yandex_vpc_subnet" "private" {
  name           = "private-ru-central1-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.private.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

# VPC NAT gateway

# VPC route table

# VPC security group