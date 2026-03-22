module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.13"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = var.cluster_version

  enable_irsa = true

  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  control_plane_subnet_ids = var.private_subnet_ids

  eks_managed_node_groups = {
    default = {
      name           = "${var.project_name}-ng"
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      subnet_ids     = var.private_subnet_ids
    }
  }

  tags = var.tags
}
