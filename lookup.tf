

data "aws_vpcs" "primary_vpc" {
  filter {
    name   = "tag:Name"
    values = ["npactsandbox-filvpc01-vpc"]
  }
}
data "aws_vpc" "primary_vpc" {
  id = tolist(data.aws_vpcs.primary_vpc.ids)[0]
}

data "aws_subnet_ids" "primary_vpc_subnets" {
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
  vpc_id = tolist(data.aws_vpcs.primary_vpc.ids)[0]
}

data "aws_ami" "cloudops_amazon_linux_2_ami" {
  most_recent = true
  # filter {
  #   name   = "name"
  #   values = ["customer Amazon Linux 2*"]
  # }
  # owners = local.ami_owners
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}