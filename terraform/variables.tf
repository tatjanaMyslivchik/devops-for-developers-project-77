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

variable "instance_count" {
  description = "Number of instances"
  default     = 2
}

# Параметры ВМ
variable "instance_cores" {
  description = "Number of CPU cores for instances"
  default     = 2
}

variable "instance_memory" {
  description = "Memory (GB) for instances"
  default     = 2
}

variable "instance_disk_size" {
  description = "Disk size (GB) for instances"
  default     = 20
}

# Параметры PostgreSQL
variable "db_resource_preset" {
  description = "Resource preset for PostgreSQL cluster"
  default     = "b2.medium"
}

variable "db_disk_size" {
  description = "Disk size (GB) for PostgreSQL"
  default     = 10
}

variable "db_disk_type" {
  description = "Disk type for PostgreSQL"
  default     = "network-ssd"
}

variable "db_version" {
  description = "PostgreSQL version"
  default     = 16
}

variable "db_name" {
  description = "Database name"
  default     = "blog_db"
}

variable "db_user" {
  description = "Database user"
  default     = "blog_user"
}