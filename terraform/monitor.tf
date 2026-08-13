resource "datadog_monitor" "app_health" {
  name    = "App Health Check"
  type    = "service check"
  query   = "\"http.can_connect\".over(\"service:redmine\").by(\"host\").last(5).count_by_status()"

  message = <<EOF
{{#is_alert}}
🚨 Приложение недоступно на хосте {{host.name}}!
Проверьте контейнер: `docker ps | grep app`
{{/is_alert}}

{{#is_recovery}}
✅ Приложение снова работает на хосте {{host.name}}.
{{/is_recovery}}
EOF

  tags = ["service:redmine", "env:production"]
}