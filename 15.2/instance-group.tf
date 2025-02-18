resource "yandex_iam_service_account" "instance-group-sa" {
  name        = "instance-group-sa"
  description = "Service account for managing the instance group"
}

resource "yandex_resourcemanager_folder_iam_member" "compute_editor" {
  folder_id  = var.folder_id
  role       = "compute.editor"
  member     = "serviceAccount:${yandex_iam_service_account.instance-group-sa.id}"
  depends_on = [
    yandex_iam_service_account.instance-group-sa,
  ]
}

resource "yandex_compute_instance_group" "instance-group" {
  name                = "instance-group"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.instance-group-sa.id}"
  depends_on          = [yandex_resourcemanager_folder_iam_member.compute_editor]
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
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
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