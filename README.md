# 무강대학교 AI 학사행정 서비스 Web APP

FastAPI + Vanilla JS 기반의 AI 학사행정 웹 애플리케이션입니다.  
학생/교직원 로그인, 수강신청, 관리자 과목관리, RAG 기반 학사 Q&A를 제공합니다.

---

## 0) 실제 AWS 운영 정보 (2026-03-14 확인)

아래 값은 로컬 AWS CLI/Terraform output 기준 실조회 값입니다.  
민감정보(비밀번호, 액세스 키 원문)는 문서에 포함하지 않았습니다.

- AWS Account ID: `410947917751`
- IAM User(배포/운영): `arn:aws:iam::410947917751:user/mugang`
- Region: `ap-northeast-2` (Seoul)
- Terraform Active Color: `blue`
- Terraform Inactive Color: `green`
- Public Entry: `http://43.201.54.86/`
- API Docs: `http://43.201.54.86/docs`
- API Health: `http://43.201.54.86/api/health`
- 참고: Public IP는 변경될 수 있으며, 최신 값은 `terraform output proxy_public_ip`로 확인

---

## 1) 주요 기능

- 학번/사번 로그인 + 초기 비밀번호 변경(First Setup)
- 수강신청/취소/장바구니/정원 초과 대기열 처리
- 관리자 기능: 과목 생성/삭제, PDF 과목 업로드, 수강신청 일정 관리
- 학생 통계/관리자 통계 API 제공
- RAG 기반 챗봇 질의응답 (`/api/v1/chat/ask`)
- AI 과목 추천 API (`/api/v1/student/ai/recommend`)
- Docker 로컬 실행 + AWS Terraform 기반 Blue/Green 배포

---

## 2) 테스트 계정

점검 기준 계정(요청 반영):

- 학생: `201811047 / 123123123`
- 교직원(관리자): `staff / 123123123`

참고: 환경별 데이터 상태에 따라 first-setup 요구 여부는 달라질 수 있습니다.

---

## 3) 기술 스택

- Backend: Python 3.11, FastAPI, SQLAlchemy, Uvicorn
- Frontend: HTML/CSS/JavaScript (Vanilla), Nginx
- Auth: JWT + bcrypt
- DB:
  - PostgreSQL (메인 트랜잭션 DB, pgvector 확장 사용)
  - DynamoDB (인프라에 `chat_history` 테이블 구성)
  - SQLite (로컬 fallback 옵션)
- AI: AWS Bedrock (임베딩/답변 생성)
- Infra: Docker, Docker Compose, Terraform, AWS (EC2/ASG/RDS/ECR/VPC)
- CI/CD: GitHub Actions

---

## 4) 저장소 분석 요약

이 저장소는 FastAPI 모놀리식 API 서버 + 정적 프론트엔드 조합입니다.  
수강신청 로직, 관리자 기능, RAG 문서 업로드/검색, 배포 인프라(Terraform)가 한 저장소에 포함돼 있습니다.

| 영역 | 실제 파일 | 역할 |
| --- | --- | --- |
| API 서버 | `backend/main.py` | 인증, 수강신청, 관리자, 챗봇, RAG API |
| 데이터 모델 | `backend/models.py` | 사용자/강의/수강/챗/RAG 테이블 ORM |
| DB 연결 | `backend/database.py` | `DATABASE_URL` 기반 엔진/세션 구성 |
| 학생 화면 | `frontend/pages/student/dashboard.html` | 수강신청 메인 UI |
| 프론트 로직 | `frontend/js/app.js` | 강의 조회/장바구니/신청 처리 |
| 챗봇 UI | `frontend/js/new_chatbot.js` | Q&A/추천 챗봇 상호작용 |
| 로컬 구성 | `docker-compose.yml` | frontend + backend + PostgreSQL(pgvector) |
| AWS 인프라 | `terraform/*.tf` | VPC, EC2 Blue/Green, RDS, DynamoDB, ECR |
| 배포 자동화 | `.github/workflows/deploy.yml` | 이미지 빌드 + Blue/Green 배포 |

현재 코드 기준 기본 운영 모델은 `Terraform + EC2 Blue/Green`입니다.

- 프록시 EC2(Nginx)가 외부 트래픽을 수신
- Blue/Green ASG를 교체하며 무중단에 가깝게 전환
- 앱 데이터는 RDS PostgreSQL에 저장
- 채팅 이력용 DynamoDB 테이블이 인프라에 준비됨

---

## 5) 환경 구분

| 환경 | 목적 | 런타임 | DB | 진입점 | 실행 기준 |
| --- | --- | --- | --- | --- | --- |
| `local` | 개인 개발/디버깅 | Docker Compose | 로컬 PostgreSQL 컨테이너 | `localhost:8888`(frontend), `localhost:8000`(API) | `docker compose up -d --build` |
| `aws-dev` | AWS 통합 검증 | EC2 + Docker | RDS PostgreSQL | `http://<proxy_public_ip>/` | `terraform apply` + Actions 배포 |
| `aws-prod-like` | 운영 시뮬레이션 | Blue/Green ASG | RDS PostgreSQL | Proxy Public IP | `deploy.yml` 워크플로 |

주의:

- 현재 저장소의 Kubernetes 매니페스트(`k8s/*`)는 보조 자료 수준이며, 실제 메인 배포는 Terraform 경로입니다.
- DynamoDB는 Terraform에 생성되며, 애플리케이션의 핵심 트랜잭션 데이터는 PostgreSQL이 담당합니다.

---

## 6) 로컬 실행 (권장 시작점)

### 6-1. 실행

```bash
docker compose up -d --build
```

### 6-2. 접속

- 프론트: `http://localhost:8888`
- 백엔드 Swagger: `http://localhost:8000/docs`
- 헬스 체크: `http://localhost:8000/api/health`
- 로컬 검증 결과(2026-03-14): `8888`, `8000/docs`, `8000/api/health` 모두 `HTTP 200`

### 6-3. 종료

```bash
docker compose down
```

데이터 볼륨까지 삭제:

```bash
docker compose down -v
```

---

## 7) 백엔드 단독 실행 (옵션)

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

환경변수 예시:

```env
DATABASE_URL=postgresql://mugang:mugang@localhost:5432/mugang
```

---

## 8) AWS 인프라 실행 (Terraform)

### 8-1. 사전 준비

- AWS CLI 인증 완료
- Terraform 설치
- `terraform/terraform.tfvars` 준비 (`db_password`, `key_name` 등)
- Terraform backend S3 버킷 준비

### 8-2. 초기화/계획/적용

```bash
cd terraform
terraform init -backend-config="bucket=<TF_STATE_BUCKET>" -backend-config="key=mugang/terraform.tfstate" -backend-config="region=ap-northeast-2"
terraform plan
terraform apply -auto-approve
```

### 8-3. 출력 확인

```bash
terraform output
```

중요 출력:

- `proxy_public_ip`
- `rds_endpoint`
- `dynamodb_table_name`
- `active_color`

---

## 8-1) 현재 AWS 리소스 스냅샷 (2026-03-14)

| 리소스 | 현재 상태 | 식별자/값 |
| --- | --- | --- |
| Proxy EC2 | Running | `i-06366a56aca980c24` / `43.201.54.86` / `10.0.1.84` |
| Blue App EC2 | Running | `i-0bfeb0b475a882908` / `10.0.2.11` |
| Green App EC2 | Stopped(Desired 0) | `mugang-green-asg` |
| ASG Blue | InService 1 | `mugang-blue-asg` |
| ASG Green | InService 0 | `mugang-green-asg` |
| RDS PostgreSQL | Available | `mugang-db.czui6uqasxf9.ap-northeast-2.rds.amazonaws.com:5432` |
| DynamoDB | ACTIVE | `mugang-chat-history` |
| ECR Backend | Created | `410947917751.dkr.ecr.ap-northeast-2.amazonaws.com/mugang-backend` |
| ECR Frontend | Created | `410947917751.dkr.ecr.ap-northeast-2.amazonaws.com/mugang-frontend` |
| VPC | Active | `vpc-05f1b055c52e0bf88` |

---

## 9) CI/CD (GitHub Actions)

현재 워크플로는 다음 흐름으로 구성됩니다.

- `.github/workflows/deploy.yml`
  - Frontend/Backend Docker 이미지 빌드
  - ECR 푸시
  - Terraform 기반 Blue/Green 전환
  - Proxy Nginx 업스트림 스위칭
- `.github/workflows/destroy.yml`
  - 수동 트리거로 전체 리소스 정리(`destroy` 확인값 필요)

배포 트리거:

- `main` 브랜치 push 시 자동 실행

---

## 10) 주요 API 엔드포인트

| 도메인 | 메서드 | 경로 |
| --- | --- | --- |
| Health | GET | `/api/health` |
| Auth | POST | `/api/v1/auth/login` |
| Auth | POST | `/api/v1/auth/first-setup` |
| Lecture | GET | `/api/v1/lectures` |
| Enrollment | POST | `/api/v1/enrollments` |
| Enrollment | DELETE | `/api/v1/enrollments/{enrollment_id}` |
| Student | GET | `/api/v1/student/{user_id}/stats` |
| AI | POST | `/api/v1/chat/ask` |
| AI | POST | `/api/v1/student/ai/recommend` |
| Admin | POST | `/api/v1/admin/courses/upload-pdf` |
| Admin | POST | `/api/v1/admin/enrollment-schedule` |
| Admin | GET | `/api/v1/admin/system-status` |

---

## 10-1) 발표용 데모 시나리오 (권장)

1. 로그인: 학생 계정(`201811047`)으로 로그인 후 대시보드 진입
2. 수강신청: 강의 필터 조회 후 장바구니 담기 및 신청
3. 챗봇 질의: `/api/v1/chat/ask` 기반으로 학사 질문 응답 확인
4. 관리자 기능: 과목/PDF 업로드 또는 수강신청 일정 설정 시연
5. 시스템 확인: `/api/v1/admin/system-status` 또는 `/api/health`로 마무리

---

## 11) 데이터베이스 구성

### 11-1. PostgreSQL (RDS / 로컬 컨테이너)

- 학사 핵심 데이터 저장
- SQLAlchemy ORM + pgvector 사용
- 로컬 Docker에서는 `pgvector/pgvector:pg16` 이미지 사용

### 11-2. DynamoDB

- Terraform에서 `mugang-chat-history` 테이블 생성
- `hash_key=session_id`, `range_key=timestamp`
- 챗봇 이력성 데이터를 위한 NoSQL 영역으로 구성

### 11-3. SQLite (Fallback)

- `DATABASE_URL` 미설정 시 개발 fallback으로 동작 가능
- 운영/검증 환경에서는 PostgreSQL 사용 권장

---

## 12) Mermaid 다이어그램

### 12-1. 배포 구조

```mermaid
flowchart LR
    USER[User Browser]
    PROXY[Proxy EC2 Nginx]
    BLUE[Blue ASG App]
    GREEN[Green ASG App]
    RDS[(RDS PostgreSQL)]
    DDB[(DynamoDB chat_history)]
    ECR[ECR]
    GH[GitHub Actions]

    USER --> PROXY
    PROXY --> BLUE
    PROXY -. switch .-> GREEN
    BLUE --> RDS
    GREEN --> RDS
    BLUE -. optional log/history .-> DDB
    GREEN -. optional log/history .-> DDB
    GH --> ECR
    GH --> BLUE
    GH --> GREEN
```

### 12-2. 챗봇 질의 흐름

```mermaid
sequenceDiagram
    participant U as User
    participant FE as Frontend
    participant API as FastAPI
    participant DB as PostgreSQL
    participant BR as AWS Bedrock

    U->>FE: 질문 입력
    FE->>API: POST /api/v1/chat/ask
    API->>DB: 세션/메시지 저장
    API->>DB: RAG 문서 벡터 검색
    API->>BR: 문맥 기반 답변 생성 요청
    BR-->>API: 생성 응답
    API->>DB: assistant 답변 저장
    API-->>FE: reply + sources
```

---

## 13) 주요 경로

- Backend API: `backend/main.py`
- Backend Model: `backend/models.py`
- Backend DB: `backend/database.py`
- Frontend Entry: `frontend/index.html`
- Frontend Main JS: `frontend/js/app.js`
- Frontend Chatbot JS: `frontend/js/new_chatbot.js`
- Local Compose: `docker-compose.yml`
- AWS Compose(참고): `docker-compose.aws.yml`
- Terraform: `terraform/*.tf`
- K8s(참고): `k8s/*.yaml`
- Deploy Workflow: `.github/workflows/deploy.yml`

---

## 14) 운영 체크 포인트

- 배포 후 `http://43.201.54.86/api/health` 응답 확인
- 배포 후 `http://43.201.54.86/docs` Swagger 확인
- Blue/Green 활성 색상은 `terraform output active_color`로 확인
- DB 접속은 RDS private 구조이므로 SSM 포트포워딩 사용

---

## 15) 향후 개선 후보

- DynamoDB 저장 경로를 백엔드 코드에 명시적으로 연결(현재는 인프라 중심)
- Alembic 기반 마이그레이션 도입
- 테스트 자동화(pytest + API 시나리오)
- Kubernetes 매니페스트와 Terraform 운영 모델 중 하나로 표준화

---

## 16) 제출용 화면 캡처 (앱)

아래 이미지는 `images/` 폴더에 저장한 수동 캡처본입니다.

1. 로그인 화면 (점검 계정 입력)  
![app-login](images/app-login.png)

2. 학생 대시보드(수강신청 + 사이드바 + 챗봇)  
![app-student-dashboard](images/app-student-dashboard.png)

3. 학생 시간표 화면  
![app-student-timetable](images/app-student-timetable.png)

4. 관리자 과목 개설 관리 화면  
![app-admin-course-management](images/app-admin-course-management.png)

5. 관리자 수강신청 일정 관리 화면  
![app-admin-enrollment-schedule](images/app-admin-enrollment-schedule.png)

6. 관리자 AI 학사 규정(RAG) 업데이트 화면  
![app-admin-rag-update](images/app-admin-rag-update.png)

7. 관리자 서버 모니터링 화면  
![app-admin-server-management](images/app-admin-server-management.png)

---

## 17) 제출용 화면 캡처 (AWS)

경로: `images/`

1. EC2 인스턴스 목록  
![aws-ec2-instances](images/aws-ec2-instances.png)

2. RDS 인스턴스 상세  
![aws-rds-detail](images/aws-rds-detail.png)

3. ECR 리포지토리 목록  
![aws-ecr-repositories](images/aws-ecr-repositories.png)

4. ECR backend 이미지 태그 상세  
![aws-ecr-backend-images](images/aws-ecr-backend-images.png)

---

## 18) 제출용 화면 캡처 (CI/CD)

경로: `images/`

1. GitHub Actions 배포 성공 및 단계 로그  
![cicd-github-actions-success](images/cicd-github-actions-success.png)

---

## 19) 캡처 촬영 가이드

- 주소창이 보이도록 캡처해 URL 증빙을 남깁니다.
- 가능하면 작업표시줄 시간까지 포함해 촬영 시점을 보여줍니다.
- 비밀번호, Access Key, Secret은 반드시 가림 처리합니다.
- 본 README는 `images/` 폴더의 캡처 파일을 기준으로 작성합니다.
