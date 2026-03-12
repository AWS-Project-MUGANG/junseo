# --------------------------------------------------------------------------------------------------
# VPC 및 네트워크 (직접 리소스 정의 - 모듈 제거로 리소스 수 최소화)
# Public Subnet 1개 (proxy EC2 + NAT GW)
# Private Subnet 2개 (blue/green EC2 + RDS)
# --------------------------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "mugang-vpc"
    Environment = "dev"
    Project     = "mugang-university"
  }
}

# ── Public Subnet (AZ-a) : Proxy EC2 + NAT Gateway ────────────────────────────
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = { Name = "mugang-public-subnet" }
}

# ── Private Subnet AZ-a : Blue EC2 + RDS ──────────────────────────────────────
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = { Name = "mugang-private-subnet-a" }
}

# ── Private Subnet AZ-c : Green EC2 + RDS ─────────────────────────────────────
resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"

  tags = { Name = "mugang-private-subnet-c" }
}

# ── Internet Gateway ───────────────────────────────────────────────────────────
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "mugang-igw" }
}

# ── EIP + NAT Gateway (Private EC2가 ECR/Bedrock 외부 통신 시 사용) ────────────
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = { Name = "mugang-nat-eip" }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags       = { Name = "mugang-nat-gw" }
  depends_on = [aws_internet_gateway.main]
}

# ── Route Tables ───────────────────────────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "mugang-public-rt" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = { Name = "mugang-private-rt" }
}

# ── Route Table Associations ───────────────────────────────────────────────────
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}
