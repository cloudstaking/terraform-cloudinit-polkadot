output "clout_init" {
  description = "The generated clout-init file for the instance"
  value       = data.cloudinit_config.validator.rendered
}

output "http_username" {
  value       = random_password.http_username.result
  description = "Username to access private endpoints (e.g node_exporter)"
}

output "http_password" {
  value       = random_password.http_password.result
  description = "Password to access private endpoints (e.g node_exporter)"
}
