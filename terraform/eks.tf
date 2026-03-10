module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  # 리소스 삭제 시 KMS 키 보존 기간 최소화 (7일)
  kms_key_deletion_window_in_days = 7

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # 워커 노드 그룹 명세 (AI용 + 일반용 통합)
  eks_managed_node_groups = {
    # 1. AI 워크로드용 노드 그룹 (t3.small)
    ai_node_group = {
      name         = "mugang-ai-nodegroup"
      min_size     = 1
      max_size     = 3
      desired_size = 2 # 기본 파드 분산을 위한 설정

      instance_types = ["t3.small"] # EKS 실행 가능한 최소 사양 (2GB RAM)
      capacity_type  = "ON_DEMAND"
      
      tags = {
        Project = "mu-gang-ai"
      }
    }

    # 2. 일반 웹/앱용 노드 그룹 (t3.medium - compute.tf 내용 통합)
    mugang_nodegroup = {
      name           = "mugang-general-nodegroup"
      instance_types = ["t3.medium"] # 인프라 분석서 기준

      min_size     = 2 # 최소 노드 수
      max_size     = 4 # 최대 노드 수 (Auto Scaling)
      desired_size = 2

      # 보안 그룹은 모듈 내부에서 자동 생성되는 것을 사용하는 것이 관리상 유리하나,
      # 별도 생성한 SG를 붙여야 한다면 아래 주석을 해제하세요.
      # vpc_security_group_ids = [aws_security_group.eks_nodes_sg.id]
      
      tags = {
        Name = "mugang-eks-nodegroup"
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "mu-gang-ai"
  }
}
