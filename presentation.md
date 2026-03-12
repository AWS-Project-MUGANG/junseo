# 무강대학교 AI 학사행정 서비스 인프라 발표 정리 (최신 반영)

## 1. 프로젝트 목표
- 비용 효율적인 AWS 기반 배포 구조 구축
- Blue/Green 배포로 무중단에 가까운 업데이트
- Terraform(IaC)로 인프라 재현 가능하게 관리
- Docker 기반 프론트/백엔드 일관 배포

---

## 2. 실제 아키텍처(현재 운영 기준)
- 사용자 접속: `Proxy EC2 (Nginx, Public)`
- 애플리케이션: `Blue/Green ASG (Private)`
- 데이터베이스: `RDS PostgreSQL (Private)`
- 챗봇 대화 저장: `DynamoDB`
- 이미지 저장소: `ECR (frontend/backend)`
- 배포 자동화: `GitHub Actions`
- 원격 운영/점검: `AWS SSM`
- Terraform state: `S3`

트래픽 라우팅:
- `/` -> frontend(80)
- `/docs`, `/api/*` -> backend(8000)

---

## 3. 발표안 대비 실제 반영 차이(핵심)
1. 인스턴스 타입 조정
- 발표안: blue/green `t3.medium`
- 실제: blue/green `t3.micro`
- 이유: 비용/프리티어 제약 대응

2. RDS 버전 표기
- 발표안: `PostgreSQL 15.3` 고정
- 실제: AWS 가용 버전 기준으로 생성(15.3 고정 제거)

3. 운영 접근 방식
- 발표안: Bastion 중심 설명
- 실제: `SSM` 기반 운영(명령 실행, 헬스체크, DB 포트포워딩)

4. 리소스 수
- 발표안 수치와 일부 차이 존재
- 실제 Terraform `aws_*` 리소스: **31개**

---

## 4. 현재 사용 리소스 요약
### 서비스 기준
- EC2
- Auto Scaling
- ECR
- RDS (PostgreSQL)
- DynamoDB
- VPC
- Security Group
- IAM
- S3
- SSM
- GitHub Actions(CI/CD)

### Terraform 리소스 타입 기준(대표)
- `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_nat_gateway`, `aws_route_table`, `aws_route_table_association`, `aws_eip`
- `aws_security_group`
- `aws_instance`, `aws_launch_template`, `aws_autoscaling_group`
- `aws_db_instance`, `aws_db_subnet_group`
- `aws_dynamodb_table`
- `aws_ecr_repository`
- `aws_iam_role`, `aws_iam_instance_profile`, `aws_iam_role_policy`
- `aws_s3_bucket`, `aws_s3_bucket_versioning`, `aws_s3_bucket_server_side_encryption_configuration`

---

## 5. 배포/운영 포인트
1. 코드 Push -> GitHub Actions 실행
2. 이미지 Build/Push(ECR)
3. Inactive ASG에 새 버전 적용
4. 헬스체크 성공 시 Proxy 업스트림 전환
5. active_color 전환 + 구 ASG 축소

운영 중 장애 대응 시 우선 확인:
- Actions 로그(health/switch/finalize)
- SSM으로 backend 컨테이너 로그
- RDS 테이블/데이터 존재 여부

---

## 6. 결론
- 발표 설계 방향(Blue/Green + IaC + Docker + AWS 핵심 서비스)은 실제 구축에 반영됨
- 다만 비용/안정성 이슈 대응으로 일부 파라미터(인스턴스 타입, 접근 방식, 버전 표기)가 실무적으로 조정됨
- 현재 기준으로 배포/운영 가능한 상태를 확보함
