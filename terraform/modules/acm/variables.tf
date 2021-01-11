variable "domain_name" {
  description = "The domain name for which the certificate should be issued"
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate."
  type    = list(string)
  default = []
}

variable "route53_zone_id" {
  description = "The ID of the Route53 zone where to create the validation records"
  type        = string
}
