locals {
    ssh-key = "ubuntu:${file(${ssh_root_key_file})}"
}