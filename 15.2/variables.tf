variable "cloud_id" {
  type        = string
  default     = "b1guau0af4j7qkg1484e"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gkg5og1lpl8fc1563m"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "public_yandex_vpc_subnet_default_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_yandex_compute_image_family" {
  type        = string
  default     = "ubuntu-2204-lts"
  description = "VM image family"
}

variable "vm_yandex_compute_instance_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "VM platform ID"
}

variable "vm_yandex_compute_instance_resources_cores" {
  type        = number
  default     = 2
  description = "Number of CPU"
}

variable "vm_yandex_compute_instance_resources_memory" {
  type        = number
  default     = 1
  description = "Number of memory"
}

variable "vm_yandex_compute_instance_resources_core_fraction" {
  type        = number
  default     = 5
  description = "Number of core fraction"
}
