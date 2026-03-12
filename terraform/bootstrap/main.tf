# --------------------------------------------------------------------------------------------------
# Bootstrap - Terraform 상태 파일용 S3 버킷
#
# 메인 Terraform과 별도로 로컬 상태를 사용합니다 (닭-달걀 문제 해결).
# 최초 1회만 실행합니다:
#   cd terraform/bootstrap
#   terraform init
#   terraform apply
#
# 전체 삭제 시에는 destroy.yml이 자동으로 처리합니다.
# --------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # 로컬 상태 파일 사용 (S3 백엔드 없음 - 의도적)
}

variable "bucket_name" {
  description = "Terraform 상태 파일용 S3 버킷 이름 (전역 유일해야 함, 예: mugang-tf-state-홍길동)"
  type        = string
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = var.bucket_name
  force_destroy = true  # terraform destroy 시 내용물 포함 삭제

  tags = { Name = "mugang-tf-state" }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_name" {
  description = "생성된 버킷 이름 (GitHub Secret TF_STATE_BUCKET에 등록)"
  value       = aws_s3_bucket.tf_state.bucket
}
