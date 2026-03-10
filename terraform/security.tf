# --------------------------------------------------------------------------------------------------
# 보안 그룹 (Security Groups)
# --------------------------------------------------------------------------------------------------
# 프로젝트의 study.md 가이드에 따라 네트워크 보안 규칙을 정의합니다.
# 1. ALB (Load Balancer): 외부 인터넷(HTTP/HTTPS)에서만 접근 허용
# 2. EKS Nodes: ALB와 노드 내부 통신만 허용
# 3. RDS (Database): EKS 노드에서만 접근 허용
# --------------------------------------------------------------------------------------------------

# 1. ALB Security Group (Public)
resource "aws_security_group" "alb_sg" {
  name        = "mugang-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. App Server Security Group (Private)
resource "aws_security_group" "app_sg" {
  name        = "mugang-app-sg"
  description = "Security group for App Server"
  vpc_id      = module.vpc.vpc_id

  # ALB에서 오는 트래픽만 허용
  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS PostgreSQL 데이터베이스를 위한 보안 그룹
resource "aws_security_group" "rds_sg" {
  name        = "mugang-rds-sg"
  description = "Security group for the RDS PostgreSQL instance"
  vpc_id      = module.vpc.vpc_id

  # EKS 노드로부터의 PostgreSQL(5432) 접근 허용
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "Allow PostgreSQL traffic from App Server"
  }

  # 외부로 나가는 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mugang-rds-sg"
  }
}