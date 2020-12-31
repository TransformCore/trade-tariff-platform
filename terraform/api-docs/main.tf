terraform {
  backend "s3" {
    bucket = "trade-tariff-terraform-state"
    key    = "api-docs"
    region = "eu-west-2"
  }
}
