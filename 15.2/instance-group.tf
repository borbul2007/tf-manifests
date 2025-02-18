resource "yandex_compute_instance_group" "instance-group" {
  name                = "instance-group"
  folder_id           = var.folder_id
  instance_template {
    platform_id = var.vm_yandex_compute_instance_platform_id
    resources {
      cores         = var.vm_yandex_compute_instance_resources_cores
      memory        = var.vm_yandex_compute_instance_resources_memory
      core_fraction = var.vm_yandex_compute_instance_resources_core_fraction
    }
    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.network.id}"
      subnet_ids = ["${yandex_vpc_subnet.private.id}"]
    }
    scheduling_policy { preemptible = true }
    metadata = {
      user-data = "${file("cloud-init.yaml")}"
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    zones = [var.default_zone]
  }
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
}