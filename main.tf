resource "aws_vpc" "dunhumby-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"

    tags {
        Name = "dunhumby-vpc"
    }
}

resource "aws_subnet" "dunhumby-subnet" {
    vpc_id = "${aws_vpc.dunhumby-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "eu-west-2a"

    tags {
        Name = "dunhumby-subnet"
    }
}

module "s3_bucket" {
  bucket_name   = var.bucket_name
  force_destroy = var.force_destroy
  tags          = local.effective_tags
}

module "bucket-iam-policy" {
  bucket_name        = var.bucket_name
  read_write_paths   = var.read_write_paths
  read_write_actions = var.read_write_actions
  tags               = local.effective_tags
}
