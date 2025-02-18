data "yandex_compute_image" "ubuntu" {
  family = var.vm_yandex_compute_image_family
}
data "yandex_compute_image" "nat" {
  family = var.vm_nat_yandex_compute_image_family
}

resource "yandex_compute_instance" "public" {
  name        = "public"
  platform_id = var.vm_yandex_compute_instance_platform_id
  zone        = var.default_zone
  resources {
    cores         = var.vm_yandex_compute_instance_resources_cores
    memory        = var.vm_yandex_compute_instance_resources_memory
    core_fraction = var.vm_yandex_compute_instance_resources_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
#      type     = "network-hdd"
#      size     = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }
  scheduling_policy { preemptible = true }
  metadata = {
    serial-port-enable = 1
    ssh-keys = "${local.ssh-key}"
  }
}

resource "yandex_compute_instance" "private" {
  name        = "private"
  platform_id = var.vm_yandex_compute_instance_platform_id
  zone        = var.default_zone
  resources {
    cores         = var.vm_yandex_compute_instance_resources_cores
    memory        = var.vm_yandex_compute_instance_resources_memory
    core_fraction = var.vm_yandex_compute_instance_resources_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
 #     type     = "network-hdd"
 #     size     = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }
  scheduling_policy { preemptible = true }
  metadata = {
    serial-port-enable = 1
    ssh-keys = "${local.ssh-key}"
  }
}

resource "yandex_compute_instance" "nat" {
  name        = "nat"
  platform_id = var.vm_yandex_compute_instance_platform_id
  zone        = var.default_zone
  resources {
    cores         = var.vm_yandex_compute_instance_resources_cores
    memory        = var.vm_yandex_compute_instance_resources_memory
    core_fraction = var.vm_yandex_compute_instance_resources_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat.image_id
#      type     = "network-hdd"
#      size     = 10
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = "192.168.10.254"
    nat                = true
  }
  scheduling_policy { preemptible = true }
  metadata = {
    serial-port-enable = 1
    user-data          = "#cloud-config\nusers:\n  - name: ubuntu\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh_authorized_keys:\n      - ${file("~/nt-ssh/id_ed25519.pub")}"
  }
}