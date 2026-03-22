locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
  })
}

module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
  tags                 = local.common_tags
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  tags         = local.common_tags
}

module "eks" {
  source              = "./modules/eks"
  project_name        = var.project_name
  cluster_version     = var.cluster_version
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  node_instance_types = var.node_instance_types
  tags                = local.common_tags
}

module "rds" {
  source         = "./modules/rds"
  project_name   = var.project_name
  use_aurora     = var.db_use_aurora
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  multi_az       = var.db_multi_az
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  db_name        = var.db_name
  username       = var.db_username
  password       = var.db_password
  allowed_cidrs  = [var.vpc_cidr]
  tags           = local.common_tags
}

module "jenkins" {
  source              = "./modules/jenkins"
  namespace           = "jenkins"
  chart_version       = "5.8.12"
  aws_region          = var.aws_region
  ecr_repository_url  = module.ecr.repository_url
  git_repository_url  = var.git_repository_url
  git_repository_branch = var.git_repository_branch
  git_username        = var.git_username
  git_token           = var.git_token
  tags                = local.common_tags
  depends_on          = [module.eks]
}

module "argo_cd" {
  source               = "./modules/argo_cd"
  namespace            = "argocd"
  chart_version        = "7.7.15"
  charts_repo_url      = var.git_repository_url
  charts_repo_path     = var.charts_repo_path
  git_repository_branch = var.git_repository_branch
  ecr_repository_url   = module.ecr.repository_url
  image_tag            = "latest"
  db_host              = module.rds.endpoint
  db_port              = tostring(module.rds.port)
  db_name              = var.db_name
  db_user              = var.db_username
  db_password          = var.db_password
  tags                 = local.common_tags
  depends_on           = [module.eks, module.rds]
}

module "monitoring" {
  source        = "./modules/monitoring"
  namespace     = "monitoring"
  chart_version = "58.6.0"
  tags          = local.common_tags
  depends_on    = [module.eks]
}
