# --------------------------------------------------------------------------------------------------
# 컴퓨팅 및 로드밸런싱 (EC2 + ALB)
# --------------------------------------------------------------------------------------------------

# 1. Application Load Balancer (트래픽 몰림 방지)
resource "aws_lb" "main" {
  name               = "mugang-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group" "app" {
  name        = "mugang-app-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
}

# 2. Application Server (Private Subnet, 보안 강화)
data "aws_caller_identity" "current" {}

resource "aws_instance" "app_server" {
  ami                    = "ami-0c9c942bd7bf113a2" # Amazon Linux 2023 (ap-northeast-2)
  instance_type          = "t3.medium"
  key_name               = var.key_name
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  # image_tag 가 바뀔 때마다 인스턴스를 재생성하여 최신 이미지를 반영합니다.
  user_data_replace_on_change = true
  user_data = <<-EOF
    #!/bin/bash
    set -e

    AWS_REGION="ap-northeast-2"
    ECR_REGISTRY="${data.aws_caller_identity.current.account_id}.dkr.ecr.$${AWS_REGION}.amazonaws.com"
    IMAGE_TAG="${var.image_tag}"

    # Docker 설치 (Amazon Linux 2023)
    dnf update -y
    dnf install -y docker
    systemctl enable --now docker
    usermod -aG docker ec2-user

    # Docker Compose 설치
    curl -fsSL \
      "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # ECR 로그인
    aws ecr get-login-password --region $${AWS_REGION} \
      | docker login --username AWS --password-stdin $${ECR_REGISTRY}

    # docker-compose.yml 생성
    mkdir -p /app
    cat <<COMPOSE > /app/docker-compose.yml
    version: '3.8'
    services:
      backend:
        image: $${ECR_REGISTRY}/mugang-backend:$${IMAGE_TAG}
        ports: ["8000:8000"]
        restart: always
      frontend:
        image: $${ECR_REGISTRY}/mugang-frontend:$${IMAGE_TAG}
        ports: ["80:80"]
        restart: always
    COMPOSE

    # 컨테이너 실행
    docker-compose -f /app/docker-compose.yml up -d
  EOF

  tags = { Name = "mugang-app-server" }
}

resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app_server.id
  port             = 8000
}

# 3. IAM Role (EC2가 DynamoDB/ECR 등에 접근하기 위함)
resource "aws_iam_role" "ec2_role" {
  name = "mugang_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "mugang_ec2_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ec2_bedrock" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
