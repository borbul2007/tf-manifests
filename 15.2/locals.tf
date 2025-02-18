locals {
    cloud-init = "${file(var.cloud-init_file)}"
}