terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  region               = var.aws_region
  project_name         = var.project_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = var.eks_cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_count      = var.eks_node_count
  node_type       = var.eks_node_type
}