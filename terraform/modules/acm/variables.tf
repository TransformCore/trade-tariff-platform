variable "hostname" {
}

variable "sans" {
  type    = list(string)
  default = []
}

variable "route53_zone_id" {
  description = "The ID of the Route53 zone where to create the Cloudfront alias CNAME records"
  type        = string
  default     = null
}
