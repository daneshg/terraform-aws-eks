output "dns_name" {
  value = aws_alb.main.dns_name
}

output "zone_id" {
  value = aws_alb.main.zone_id
}

output "route_53_hostname" {
  value = element(aws_route53_record.hostname[*].name, 0)
}

output "route_53_fqdn" {
  value = element(aws_route53_record.hostname[*].fqdn, 0)
}
