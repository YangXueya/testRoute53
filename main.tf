
locals {
  prefix="route53"
  workspace = var.workspace == null ? terraform.workspace : var.workspace
  default_tags = {
    app_id        = var.app_id
    chargeback_id = var.chargeback_id != null ? var.chargeback_id : var.app_id
    environment   = local.workspace
    product       = var.product_name
  }
  vpc_cidr ="10.58.140.0/25"
  subnet_bits=7

}

resource "aws_instance" "ec2_instance" {
  
  ami                         = "ami-0df99b3a8349462c6"
  instance_type               = "t2.micro"
  key_name                    = "myKeyPair"
  iam_instance_profile        = module.ec2_iam_role.instnce_profile_name
  associate_public_ip_address = true
  
  vpc_security_group_ids      = [module.web_server_sg.id]
  subnet_id                   = "subnet-097a9362dab87855a"

  user_data   = "${file("files/userdata.txt")}"
  tags = local.default_tags
  depends_on = [
    module.ec2_iam_role
  ]
  
}

module "ec2_iam_role" {
  source       = "git::https://github.com/Deloitte/tfmodule-iam-role.git"
  app_id       = var.app_id
  product_name = var.product_name
  environment  = local.workspace

  is_ec2_role          = true
  name                 = "route53-role"
  path                 = "/"
  description          = "Route53 role"
  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }

    ]
  })
    inline_policy = [
    {
      name = "codedeploy-policy"
      policy = jsonencode({

        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "autoscaling:*",
              "codedeploy:*",
              "ec2:*",
              "lambda:*",
              "ecs:*",
              "elasticloadbalancing:*",
              "iam:AddRoleToInstanceProfile",
              "iam:AttachRolePolicy",
              "iam:CreateInstanceProfile",
              "iam:CreateRole",
              "iam:DeleteInstanceProfile",
              "iam:DeleteRole",
              "iam:DeleteRolePolicy",
              "iam:GetInstanceProfile",
              "iam:GetRole",
              "iam:GetRolePolicy",
              "iam:ListInstanceProfilesForRole",
              "iam:ListRolePolicies",
              "iam:ListRoles",
              "iam:PassRole",
              "iam:PutRolePolicy",
              "iam:RemoveRoleFromInstanceProfile",
              "s3:*",
            "ssm:*"],
            "Resource" : "*"
        }]
      })
    },
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    
  ]


}

module "web_server_sg" {
  source       = "git::https://github.com/Deloitte/tfmodule-security-group.git"
  app_id       = var.app_id
  product_name = var.product_name
  environment  = local.workspace

  name        = "web-sg"
  description = "EC2"

  vpc_id      = tolist(data.aws_vpcs.primary_vpc.ids)[0]
  rules = [
    {
      type        = "ingress"
      description = "http api"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      cidr_blocks = ["0.0.0.0/0"]
    },    
    {
      type        = "egress"
      description = "http api"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      cidr_blocks = ["0.0.0.0/0"]
    },
    ]
}
module "route53-zone" {
  source  = "../tfmodule-route53-zones"
  name    = "app.terraform-aws-modules-route53-example.com"
  comment = "app.terraform-aws-modules-example.com"
  tags = {
    Name = "app.terraform-aws-modules-example.com"
  }
  app_id        = var.app_id
  chargeback_id = var.chargeback_id != null ? var.chargeback_id : var.app_id
  environment   = local.workspace
  product_name  = var.product_name
  vpc = [{vpc_id =data.aws_vpc.primary_vpc.id}]


}


module "records" {
  source = "../terraform-route53-records"

  zone_id = module.route53-zone.zone_id

  records = [
      {
      name = "simple"
      type = "A"
      ttl  = 3600
      records = [
        "10.10.10.10",
      ]
    },
    {
      name           = "weight"
      type           = "CNAME"
      ttl            = 5
      records        = ["11.11.11.11"]
      set_identifier = "test-weighted-1"
      weighted_routing_policy = {
        weight = 5
      }
      
    },
    {
      name           = "weight"
      type           = "CNAME"
      ttl            = 5
      records        = ["11.11.11.12"]
      set_identifier = "test-weighted-2"
      weighted_routing_policy = {
        weight = 50
      }
    },
    {
      name           = "latency"
      type           = "CNAME"
      ttl            = 5
      records        = ["22.22.22.22"]
      set_identifier = "test-latency-1"
      latency_routing_policy = {
        region = "ap-east-1"
      }
    },
    {
      name           = "latency"
      type           = "CNAME"
      ttl            = 5
      records        = ["22.22.22.23"]
      set_identifier = "test-latency-2"
      latency_routing_policy = {
        region = "ap-northeast-1"
      }
    },
    {
      name           = "geolocation"
      type           = "CNAME"
      ttl            = 5
      records        = ["33.33.33.34"]
      set_identifier = "test-geolocation-1"
      geolocation_routing_policy = {
        country = "JP"
      }
    },
    {
      name           = "geolocation"
      type           = "CNAME"
      ttl            = 5
      records        = ["33.33.33.33"]
      set_identifier = "test-geolocation-2"
      geolocation_routing_policy = {
        country = "CN"
      }
    },


  
  ]

}