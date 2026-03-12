# --------------------------------------------------------------------------------------------------
# 출력 (Outputs)
# --------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "proxy_public_ip" {
  description = "Proxy EC2 공개 IP (사용자 접속 엔드포인트)"
  value       = aws_instance.proxy.public_ip
}

output "rds_endpoint" {
  description = "RDS PostgreSQL 엔드포인트"
  value       = aws_db_instance.postgres_db.address
}

output "dynamodb_table_name" {
  description = "DynamoDB 테이블 이름"
  value       = aws_dynamodb_table.chat_history.name
}

output "active_color" {
  description = "현재 라이브 환경 색 (blue 또는 green)"
  value       = var.active_color
}

output "inactive_color" {
  description = "현재 대기 환경 색 (다음 배포 대상)"
  value       = local.inactive_color
}

output "ecr_registry" {
  description = "ECR 레지스트리 URL (계정ID.dkr.ecr.리전.amazonaws.com)"
  value       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com"
}
