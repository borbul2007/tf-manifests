data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "public" {
  name        = "public"
  platform_id = "standard-v1"
  zone        = var.default_zone
  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }
  scheduling_policy { preemptible = true }
  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
}

resource "yandex_compute_instance" "private" {
  name        = "private"
  platform_id = "standard-v1"
  zone        = var.default_zone
  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }
  scheduling_policy { preemptible = true }
  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
}