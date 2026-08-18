
# Сеть используем существующую
data "yandex_vpc_network" "blog" {
  name = "blog-network"
}

# Подсеть используем существующую
data "yandex_vpc_subnet" "blog" {
  name = "blog-subnet"
}

# Используем существующую DNS-зону
data "yandex_dns_zone" "blog" {
  name = "mt-blog-project"
}

# Используем существующий сертификат
data "yandex_cm_certificate" "blog" {
  name = "blog-certificate"
}

data "ansible_vault" "db_password" {
  vault_file = "../ansible/group_vars/all/vault.yml"
  key        = "db_password"
}

# Группа безопасности для балансировщика
resource "yandex_vpc_security_group" "alb" {
  name        = "alb-sg"
  network_id  = data.yandex_vpc_network.blog.id

  dynamic "ingress" {
    for_each = [
      { port = 80, description = "HTTP" },
      { port = 443, description = "HTTPS" }
    ]
    content {
      protocol       = "TCP"
      description    = ingress.value.description
      port           = ingress.value.port
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Группа безопасности для ВМ
resource "yandex_vpc_security_group" "vm" {
  name       = "vm-sg-tf"
  network_id = data.yandex_vpc_network.blog.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "Traffic from alb"
    port              = 8080
    security_group_id = yandex_vpc_security_group.alb.id
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Данные для образа Ubuntu
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Виртуальные машины
resource "yandex_compute_instance" "app" {
  count = var.instance_count
  name  = "blog-web-tf${count.index + 1}"
  zone  = var.yc_zone

  resources {
    cores  = var.instance_cores
    memory = var.instance_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.blog.id
    security_group_ids = [yandex_vpc_security_group.vm.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Кластер PostgreSQL
resource "yandex_mdb_postgresql_cluster" "blog" {
  name        = "blog-db"
  environment = "PRESTABLE"
  network_id  = data.yandex_vpc_network.blog.id

  config {
    version = var.db_version
    resources {
      resource_preset_id = var.db_resource_preset
      disk_type_id       = var.db_disk_type
      disk_size          = var.db_disk_size
    }
  }

  host {
    zone      = var.yc_zone
    subnet_id = data.yandex_vpc_subnet.blog.id
  }
}

# База данных
resource "yandex_mdb_postgresql_database" "blog" {
  cluster_id = yandex_mdb_postgresql_cluster.blog.id
  name       = "blog_db"
  owner      = yandex_mdb_postgresql_user.blog.name
}

# Пользователь базы данных
resource "yandex_mdb_postgresql_user" "blog" {
  cluster_id = yandex_mdb_postgresql_cluster.blog.id
  name       = var.db_user
  password   = data.ansible_vault.db_password.value
}

# Целевая группа
resource "yandex_alb_target_group" "blog" {
  name = "blog-target-group-tf"

  dynamic "target" {
    for_each = yandex_compute_instance.app
    content {
      subnet_id  = data.yandex_vpc_subnet.blog.id
      ip_address = target.value.network_interface.0.ip_address
    }
  }
}

# Группа бэкендов
resource "yandex_alb_backend_group" "blog" {
  name = "blog-backend-group-tf"

  http_backend {
    name             = "blog-backend"
    weight           = 1
    port             = 8080
    target_group_ids = [yandex_alb_target_group.blog.id]
    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout             = "5s"
      interval            = "10s"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP-роутер
resource "yandex_alb_http_router" "blog" {
    name = "blog-router-tf"
}

# Балансировщик
resource "yandex_alb_load_balancer" "blog" {
  name = "blog-lb-tf"
  network_id = data.yandex_vpc_network.blog.id
  security_group_ids = [yandex_vpc_security_group.alb.id]

  allocation_policy {
    location {
      zone_id   = var.yc_zone
      subnet_id = data.yandex_vpc_subnet.blog.id
    }
  }

  listener {
    name = "https-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [443]
    }
    tls {
      default_handler {
        certificate_ids = [data.yandex_cm_certificate.blog.id]
        http_handler {
          http_router_id = yandex_alb_http_router.blog.id
        }
      }
    }
  }
}

# A-запись
resource "yandex_dns_recordset" "blog" {
  zone_id = data.yandex_dns_zone.blog.id
  name    = var.domain_name
  type    = "A"
  ttl     = 21600
  data    = [yandex_alb_load_balancer.blog.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

# A-запись для www
resource "yandex_dns_recordset" "blog_www" {
  zone_id = data.yandex_dns_zone.blog.id
  name    = "www.${var.domain_name}"
  type    = "A"
  ttl     = 21600
  data    = [yandex_alb_load_balancer.blog.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    vm_ips = [for instance in yandex_compute_instance.app : instance.network_interface[0].nat_ip_address]
  })
  filename = "../ansible/inventory.ini"
}

resource "local_file" "ansible_vars" {
  content = templatefile("${path.module}/templates/ansible_vars.tpl", {
    db_host = yandex_mdb_postgresql_cluster.blog.host[0].fqdn
    db_name = var.db_name
    db_user = var.db_user
  })
  filename = "../ansible/group_vars/all/main.yml"
}
