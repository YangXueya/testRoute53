locals {
  default_tags = {
    product = var.product_name
    "owner" = var.owner
  }
  prefix                = "master-${var.product_name}-${var.environment}"
  alarm_topic_name      = "EC2 instance"
  secondary_private_ips = [["172.16.3.201", "172.16.3.200"], ["172.16.5.201", "172.16.5.200"]]
  private_ips           = ["172.16.3.199", "172.16.5.199"]
}



module "records" {
  source = "git::https://github.com/Deloitte/tfmodule-route53-records.git"

  zone_id = "Z00447464NRDKLMBTDZB"
  
  records = [
    {
      name = "testrecord"
      type = "A"
      ttl  = 3600
      records = [
        "10.10.10.10",
      ]
    }
  ]
}