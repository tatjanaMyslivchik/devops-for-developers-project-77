# terraform {
#   backend "s3" {
#     endpoints = {
#       s3 = "https://storage.yandexcloud.net"
#     }
#     bucket                      = "tf-state-77"
#     region                      = "ru-central1"
#     key                         = "devops-for-developers-project-77/terraform.tfstate"
#     skip_region_validation      = true
#     skip_credentials_validation = true
#     skip_requesting_account_id  = true
#   }
# }


terraform {
  backend "local" {
  }
}