terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.8.4"
}

provider "yandex" {
  cloud_id                 = "b1guau0af4j7qkg1484e"
  folder_id                = "b1gb1gkg5og1lpl8fc1563m"
  service_account_key_file = file("~/key.json")
  zone                     = "ru-central1-a"
}
