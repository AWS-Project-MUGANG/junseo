# AWS Runbook (junseo)

이 문서는 현재 `junseo` 프로젝트의 AWS 배포/운영을 위한 실무용 가이드입니다.

## 0) 현재 배포 상태 요약
- 배포 방식: `GitHub Actions + Terraform + Docker(ECR 이미지)`
- 앱 접속: `http://13.124.164.171/`
- API 문서: `http://13.124.164.171/docs`
- DB: AWS RDS PostgreSQL (`mugang`)
- 챗봇 이력: DynamoDB (`mugang-chat-history`)

참고: IP는 바뀔 수 있으므로 아래 명령으로 항상 최신값 확인.
```powershell
cd C:\Users\junse\Desktop\vscode\team-project\junseo\terraform
& "C:\terraform\terraform.exe" output
```

---

## 사용 리소스 정리
### A. 서비스 기준
| 구분 | 사용 서비스 | 용도 |
|---|---|---|
| 컴퓨팅 | EC2 | Proxy + 앱 인스턴스 실행 |
| 오토스케일 | Auto Scaling | Blue/Green 인스턴스 교체/유지 |
| 컨테이너 레지스트리 | ECR | 프론트/백 도커 이미지 저장 |
| 관계형 DB | RDS PostgreSQL | 서비스 메인 데이터 저장 |
| NoSQL | DynamoDB | 챗봇 대화 이력 저장 |
| 네트워크 | VPC | Subnet/Route/NAT/IGW 네트워크 구성 |
| 보안 | Security Group | 포트/통신 제어 |
| 권한 | IAM | EC2/배포 권한 부여 |
| 상태저장 | S3 | Terraform state 저장 |
| 운영접속 | SSM | 원격 명령/헬스체크/DB 터널 |
| CI/CD | GitHub Actions | 빌드/배포 자동화 |

### B. Terraform 리소스 기준(대표)
| 범주 | 주요 리소스(예시) |
|---|---|
| 네트워크 | `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_nat_gateway`, `aws_route_table`, `aws_route_table_association`, `aws_eip` |
| 보안 | `aws_security_group`(proxy/app/rds) |
| 컴퓨트 | `aws_instance.proxy`, `aws_launch_template.blue`, `aws_launch_template.green`, `aws_autoscaling_group.blue`, `aws_autoscaling_group.green` |
| 데이터 | `aws_db_instance.postgres_db`, `aws_db_subnet_group`, `aws_dynamodb_table.chat_history` |
| 이미지 저장소 | `aws_ecr_repository.frontend`, `aws_ecr_repository.backend` |
| 권한 | `aws_iam_role`, `aws_iam_instance_profile`, `aws_iam_role_policy` |
| 출력/운영 | `output.proxy_public_ip`, `output.rds_endpoint`, `output.active_color` |

---

## 1) 오늘 작업 시작할 때 (기본 순서)
### 1-1. 코드 최신화
```powershell
cd C:\Users\junse\Desktop\vscode\team-project\junseo
git pull
```

### 1-2. 인프라 상태 확인
```powershell
cd terraform
& "C:\terraform\terraform.exe" init -backend-config="bucket=mugang-s3" -backend-config="key=mugang/terraform.tfstate" -backend-config="region=ap-northeast-2"
& "C:\terraform\terraform.exe" plan
```

### 1-3. 필요한 경우 반영
```powershell
& "C:\terraform\terraform.exe" apply -auto-approve
```

### 1-4. 앱 확인
- `http://<proxy_public_ip>/`
- `http://<proxy_public_ip>/docs`

---

## 2) 배포(코드 변경 반영)
### 2-1. GitHub Actions 배포
```powershell
cd C:\Users\junse\Desktop\vscode\team-project\junseo
git add .
git commit -m "deploy: <내용>"
git push
```
- `Actions > Blue-Green Deploy to ECR & EC2` 성공 확인

### 2-2. 배포 후 헬스체크
```powershell
curl.exe -I http://13.124.164.171/
curl.exe -I http://13.124.164.171/docs
curl.exe -i http://13.124.164.171/api/time
```

---

## 3) DB(DBeaver) 연결 가이드
RDS가 private 서브넷이라 직접 접속이 안 됨. SSM 포트포워딩 필수.

### 3-1. 플러그인 경로 보장 (한 번 실행)
```powershell
$env:Path="C:\Program Files\Amazon\SessionManagerPlugin\bin;$env:Path"
```

### 3-2. 포트포워딩 시작
```powershell
# 매번 현재 InService 인스턴스를 조회해서 target으로 사용
$iid = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" autoscaling describe-auto-scaling-instances `
  --query "AutoScalingInstances[?LifecycleState=='InService'].InstanceId | [0]" `
  --output text `
  --region ap-northeast-2

# SSM 연결 상태 확인(Online 이어야 포트포워딩 가능)
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" ssm describe-instance-information `
  --filters "Key=InstanceIds,Values=$iid" `
  --query "InstanceInformationList[0].PingStatus" `
  --output text `
  --region ap-northeast-2

& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" ssm start-session `
  --target $iid `
  --document-name AWS-StartPortForwardingSessionToRemoteHost `
  --parameters host="mugang-db.czui6uqasxf9.ap-northeast-2.rds.amazonaws.com",portNumber="5432",localPortNumber="15432" `
  --region ap-northeast-2
```
- 이 창은 닫지 말 것 (닫으면 DB 연결 끊김)

### 3-3. DBeaver 입력값
- Host: `127.0.0.1`
- Port: `15432`
- Database: `mugang`
- Username: `mugangadmin`
- Password: `terraform/terraform.tfvars`의 `db_password`

---

## 4) 하루 작업 끝났을 때 (비용 절감)
아래 두 가지 중 하나 선택.

## A안) 완전 종료(권장: 비용 최소)
모든 리소스 제거.
```powershell
cd C:\Users\junse\Desktop\vscode\team-project\junseo\terraform
& "C:\terraform\terraform.exe" destroy -auto-approve
```
- 장점: 비용 최소
- 단점: 다음날 다시 `apply` 필요, 퍼블릭 IP 바뀜

## B안) 부분 종료(빠른 재시작)
- ASG 인스턴스 0으로 축소
- RDS stop(최대 7일)

```powershell
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" autoscaling update-auto-scaling-group --auto-scaling-group-name mugang-blue-asg --desired-capacity 0 --region ap-northeast-2
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" autoscaling update-auto-scaling-group --auto-scaling-group-name mugang-green-asg --desired-capacity 0 --region ap-northeast-2
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" rds stop-db-instance --db-instance-identifier mugang-db --region ap-northeast-2
```

다시 시작:
```powershell
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" rds start-db-instance --db-instance-identifier mugang-db --region ap-northeast-2
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" autoscaling update-auto-scaling-group --auto-scaling-group-name mugang-blue-asg --desired-capacity 1 --region ap-northeast-2
```

---

## 5) 자주 쓰는 점검 명령
### 5-1. 현재 활성 ASG 인스턴스 확인
```powershell
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" autoscaling describe-auto-scaling-instances --query "AutoScalingInstances[?LifecycleState=='InService'].[AutoScalingGroupName,InstanceId]" --output table --region ap-northeast-2
```

### 5-2. 프록시 퍼블릭 IP 확인
```powershell
cd C:\Users\junse\Desktop\vscode\team-project\junseo\terraform
& "C:\terraform\terraform.exe" output -raw proxy_public_ip
```

### 5-3. API 상태 확인
```powershell
curl.exe -i http://13.124.164.171/api/time
```

---

## 6) 사고 방지 체크리스트
- AWS 키/비밀번호 절대 채팅/문서에 노출 금지
- `terraform.tfvars`는 Git 커밋 금지
- 배포 실패 시 먼저 `Actions 로그` + `backend 컨테이너 로그` 확인
- DB 마이그레이션 작업 전 반드시 백업

---

## 7) 이번에 실제로 반영된 핵심 변경
- Nginx 라우팅 분기:
  - `/` -> frontend(80)
  - `/docs`, `/api/*` -> backend(8000)
- app SG 인바운드 추가:
  - proxy_sg -> app_sg `80/tcp` 허용
- DB 복구/이관으로 필수 테이블/데이터 반영 완료
