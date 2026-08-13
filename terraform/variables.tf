variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
}

variable "yc_zone" {
  description = "Yandex Cloud Zone"
  default     = "ru-central1-a"
}

variable "db_password" {
  description = "Password for database user"
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name"
  default     = "mt-blog-project-74.online"
}

variable "datadog_api_key" {
  description = "Datadog API key"
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog APP key"
  sensitive   = true
}

variable "datadog_api_url" {
  type        = string
  description = "Региональный API URL Datadog (.eu для Европы, .com для США)"
  default     = "https://datadoghq.eu"
}