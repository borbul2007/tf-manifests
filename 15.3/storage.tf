resource "yandex_storage_bucket" "bucket" {
  bucket = var.bucket_name
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
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
