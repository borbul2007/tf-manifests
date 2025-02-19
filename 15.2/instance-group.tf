data "yandex_compute_image" "lamp" {
  family = var.vm_yandex_compute_image_family
}

#resource "yandex_iam_service_account" "instance-group-sa" {
#  name        = "instance-group-sa"
#  description = "Service account for managing the instance group"
#}
#resource "yandex_resourcemanager_folder_iam_member" "compute_editor" {
#  folder_id  = var.folder_id
#  role       = "editor"
#  member     = "serviceAccount:${yandex_iam_service_account.instance-group-sa.id}"
#  depends_on = [yandex_iam_service_account.instance-group-sa]
#}
#resource "yandex_resourcemanager_folder_iam_member" "load_balancer_editor" {
#  folder_id = var.folder_id
#  role      = "load-balancer.editor"
#  member    = "serviceAccount:${yandex_iam_service_account.instance-group-sa.id}"
#  depends_on = [yandex_iam_service_account.instance-group-sa]
#}

resource "yandex_compute_instance_group" "instance-group" {
  name                = "instance-group"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.instance-group-sa.id}"
  #depends_on          = [yandex_resourcemanager_folder_iam_member.compute_editor,yandex_resourcemanager_folder_iam_member.load_balancer_editor]
  instance_template {
    platform_id = var.vm_yandex_compute_instance_platform_id
    resources {
      cores         = var.vm_yandex_compute_instance_resources_cores
      memory        = var.vm_yandex_compute_instance_resources_memory
      core_fraction = var.vm_yandex_compute_instance_resources_core_fraction
    }
    boot_disk {
      initialize_params {
      image_id = data.yandex_compute_image.lamp.image_id
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.network.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
    }
    scheduling_policy { preemptible = true }
    metadata = {
      serial-port-enable = 1
      user-data          = "${local.cloud-init}"
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
  health_check {
    interval            = 2
    timeout             = 1
    healthy_threshold   = 2
    unhealthy_threshold = 2
    http_options {
      port = 80
      path = "/"
    }
  }
  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Network Load Balancer target group"
  }
}
