locals {
    ssh-key = "ubuntu:${file(var.ssh_root_key_file)}"
}