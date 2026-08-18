[webservers]
{{- range $index, $ip := .vm_ips }}
web{{ $index + 1 }} ansible_host={{ $ip }} ansible_user=ubuntu
{{- end }}