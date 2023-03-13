data "aws_route53_zone" "main" {
  name = "bagbaga-glaa.click"

}

resource "aws_route53_record" "main" {
  name    = "2048.${data.aws_route53_zone.main.name}"
  type    = "CNAME"
  zone_id = data.aws_route53_zone.main.zone_id
  ttl     = 300
  records = [module.lb.dns_name]
}
