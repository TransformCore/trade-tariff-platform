variable "environment_name" {
}

variable "environment_key" {
}

variable "cdn_aliases" {
  type = list(string)
}

variable "origin_endpoint" {
}


variable "base_domain_name" {
  type    = string
  default = "trade-tariff.service.gov.uk."
}
