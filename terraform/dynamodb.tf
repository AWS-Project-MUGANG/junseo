# 채팅 기록 및 비정형 데이터 저장용 DynamoDB
resource "aws_dynamodb_table" "chat_history" {
  name           = "mugang-chat-history"
  billing_mode   = "PAY_PER_REQUEST" # 트래픽 변동에 유리하고 비용 효율적
  hash_key       = "session_id"
  range_key      = "timestamp"

  attribute {
    name = "session_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  tags = { Name = "mugang-chat-history" }
}