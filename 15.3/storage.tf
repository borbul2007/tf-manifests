resource "yandex_storage_bucket" "bucket" {
  bucket = var.bucket_name
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
}
