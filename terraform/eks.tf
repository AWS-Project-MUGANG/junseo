module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # 워커 노드 그룹 명세
  eks_managed_node_groups = {
    ai_node_group = {
      min_size     = 1
      max_size     = 3
      desired_size = 2 # 기본 파드 분산을 위한 설정

      instance_types = ["t3.medium"] # 램 4GB급 웹서비스용 인스턴스
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "mu-gang-ai"
  }
}
