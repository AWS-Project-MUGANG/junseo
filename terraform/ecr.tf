# --------------------------------------------------------------------------------------------------
# ECR 리포지토리 - 프론트엔드 / 백엔드 Docker 이미지 저장소
# force_delete = true → 이미지가 남아 있어도 terraform destroy 한 번에 삭제
# --------------------------------------------------------------------------------------------------

resource "aws_ecr_repository" "frontend" {
  name         = "mugang-frontend"
  force_delete = true

  tags = { Name = "mugang-frontend" }
}

resource "aws_ecr_repository" "backend" {
  name         = "mugang-backend"
  force_delete = true

  tags = { Name = "mugang-backend" }
}
