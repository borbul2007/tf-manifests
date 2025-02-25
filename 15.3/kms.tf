resource "yandex_iam_service_account" "storage-admin" {
  name = "storage-admin"
}

resource "yandex_resourcemanager_folder_iam_member" "storage-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage-admin.id}"
}

resource "yandex_iam_service_account_static_access_key" "key" {
  service_account_id = yandex_iam_service_account.storage-admin.id
  description        = "static access key for object storage"
}

resource "yandex_kms_symmetric_key" "key" {
  name              = "key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}
