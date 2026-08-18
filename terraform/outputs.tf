output "vm_ips" {
  value = [for instance in yandex_compute_instance.app : instance.network_interface[0].nat_ip_address]
}

output "vm_internal_ips" {
  value = [for instance in yandex_compute_instance.app : instance.network_interface[0].ip_address]
}

output "db_host" {
  value = yandex_mdb_postgresql_cluster.blog.host[0].fqdn
}