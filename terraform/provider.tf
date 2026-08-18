terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.120"
    }

    datadog = {
      source = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
#   required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url  = var.datadog_api_url
}

provider "ansible-vault" {
  secret_file = "../ansible/group_vars/all/vault.yml"
}