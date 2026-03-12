variable "db_password" {
  description = "RDS 데이터베이스 비밀번호"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "RDS 데이터베이스 이름"
  type        = string
  default     = "mugang"
}

variable "db_username" {
  description = "RDS 데이터베이스 사용자명"
  type        = string
  default     = "mugangadmin"
}

variable "key_name" {
  description = "EC2 접속에 사용할 키 페어 이름"
  type        = string
}

variable "blue_image_tag" {
  description = "Blue 환경 Docker 이미지 태그"
  type        = string
  default     = "latest"
}

variable "green_image_tag" {
  description = "Green 환경 Docker 이미지 태그"
  type        = string
  default     = "latest"
}

variable "active_color" {
  description = "현재 라이브 환경 (blue 또는 green)"
  type        = string
  default     = "blue"
}

variable "blue_desired" {
  description = "Blue ASG desired capacity (0 또는 1)"
  type        = number
  default     = 1
}

variable "green_desired" {
  description = "Green ASG desired capacity (0 또는 1)"
  type        = number
  default     = 0
}

variable "log_retention_days" {
  description = "CloudWatch Logs 보관 기간(일)"
  type        = number
  default     = 14
}
