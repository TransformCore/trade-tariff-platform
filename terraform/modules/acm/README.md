# ACM

A terraform module that creates a certificate in AWS Certificate Manager, using DNS for 
validation 

### Usage

```
module "acm" {
  source = "../modules/acm"

  domain_name                = "www.hostname.com"
  subject_alternative_names  = ["static.hostname.com", "images.hostname.com"]
  route53_zone_id = data.aws_route53_zone.selected.id
}
```
