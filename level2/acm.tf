resource "aws_acm_certificate" "main" {
  domain_name       = "2048.bagbaga-glaa.click"
  validation_method = "DNS"
  tags = {
    Name = var.env_code
  }
}

resource "aws_route53_record" "domain_validation" {
  for_each = {
    for i in aws_acm_certificate.main.domain_validation_options : i.domain_name => {
      name   = i.resource_record_name
      record = i.resource_record_value
      type   = i.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = data.aws_route53_zone.main.zone_id

}

resource "aws_acm_certificate_validation" "cert_vald" {

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation : record.fqdn]
}


