output "alb-listener-arn" {
  value = aws_alb_listener.this_http_listener.arn
}

output "alb-zone-id" {
  value = aws_alb.this_alb.zone_id
}

output "alb-dns-name" {
  value = aws_alb.this_alb.dns_name
}


//output "acm-cert-arn" {
//  value = data.aws_acm_certificate.certificate.arn
//}
