resource "yandex_storage_bucket" "bucket" {
  bucket = "boris-18-02-2025"
  anonymous_access_flags {
    read        = true
    list        = true
    config_read = true
  }
}
