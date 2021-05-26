data "aws_route53_zone" "selected" {
  name         = "trade-tariff.service.gov.uk."
  private_zone = false
}

resource "aws_route53_record" "google_validation" {
  zone_id = data.aws_route53_zone.selected.id
  name = "trade-tariff.service.gov.uk"
  type = "TXT"
  ttl = "300"
  records = ["google-site-verification=cX_NM0eTiZv7isZsA-FsTMpPahArshEhyPNOKUG4Nxk"]
}
