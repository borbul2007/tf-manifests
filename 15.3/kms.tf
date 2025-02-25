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

resource "yandex_storage_bucket" "test" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.key.access_key
  secret_key = yandex_iam_service_account_static_access_key.key.secret_key
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
