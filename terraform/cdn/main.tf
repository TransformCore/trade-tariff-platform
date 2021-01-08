terraform {
  backend "s3" {
  }
}

provider "aws" {
  alias  = "global"
  region = "us-east-1"
}

data "aws_route53_zone" "selected" {
  name         = var.base_domain_name
  private_zone = false
}

module "cdn" {
  source = "../modules/cloudfront"

  aliases         = var.cdn_aliases
  route53_zone_id = data.aws_route53_zone.selected.id

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

  logging_config = {
    bucket = "trade-tariff-logs.s3.amazonaws.com"
    prefix = "cloudfront/${var.environment_key}"
  }

  origin = {
    "frontend-govpaas-${var.environment_name}" = {
      domain_name = var.origin_endpoint
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols = [
        "TLSv1"]
      }
    }
  }

  cache_behavior = {
    default = {
      target_origin_id       = "frontend-govpaas-${var.environment_name}"
      viewer_protocol_policy = "redirect-to-https"

      default_ttl = 0
      max_ttl     = 0

      compress        = true
      cookies_forward = "all"
      headers         = ["*"]
      query_string    = true

      allowed_methods = [
        "GET",
        "HEAD",
        "OPTIONS",
        "PUT",
        "POST",
        "PATCH",
        "DELETE"
      ]

      cached_methods = [
        "GET",
        "HEAD"
      ]
    }

  }
  viewer_certificate = {
    ssl_support_method  = "sni-only"
    acm_certificate_arn = module.acm.certificate_arn
  }
}

module "acm" {
  providers = {
    aws = aws.global
  }

  source = "../modules/acm"

  hostname        = var.cdn_aliases[0]
  sans            = slice(var.cdn_aliases, 1, length(var.cdn_aliases))
  route53_zone_id = data.aws_route53_zone.selected.id
}
