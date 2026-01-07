locals {
  azs = ["ap-south-1a", "ap-south-1b"]
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"


  name = "${var.name}-vpc"
  cidr = var.vpc_cidr
  azs             = local.azs


  private_subnets = ["10.30.0.0/20", "10.30.16.0/20"]
  public_subnets  = ["10.30.64.0/20", "10.30.80.0/20"]

  enable_nat_gateway = false
  map_public_ip_on_launch = true


  enable_dns_hostnames = true
  enable_dns_support   = true
  create_igw           = true



  tags = var.tags
}

####################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = var.name
  kubernetes_version = var.eks_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  endpoint_public_access  = true   # simple for practice
  endpoint_private_access = true

  enable_irsa = true

  eks_managed_node_groups = {
    spot-t3 = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
      ami_type = "AL2023_x86_64_STANDARD"

      labels = { workload = "practice" }
      tags   = merge(var.tags, { NodeGroup = "spot-t3" })
    }
  }

  addons = {
    vpc-cni   = { most_recent = true }
    kube-proxy = { most_recent = true }
    coredns   = { most_recent = true }
  }

  tags = var.tags
}


