terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "mugang-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # 비용 절감을 위해 NAT Gateway 1개만 생성

  public_subnet_tags = {
    "kubernetes.io/cluster/mugang-eks" = "shared"
    "kubernetes.io/role/elb"           = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/mugang-eks" = "shared"
    "kubernetes.io/role/internal-elb"  = "1"
  }

  tags = {
    Project = "mugang"
  }
}