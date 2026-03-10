현재 프로젝트에서 사용하는 AWS 리소스 분석
현재 프로젝트의 Terraform 코드를 분석한 결과, 다음과 같은 AWS 리소스들이 생성됩니다. 리소스는 각 .tf 파일 및 모듈별로 분류했습니다.

1. VPC 및 네트워킹 (main.tf)
VPC와 서브넷, 인터넷 연결을 위한 기본적인 네트워크 인프라를 구성합니다.

aws_vpc: 1개
aws_subnet: 4개 (Public 2개, Private 2개)
aws_internet_gateway: 1개
aws_eip: 1개 (NAT 게이트웨이용)
aws_nat_gateway: 1개
aws_route_table: 2개 (Public 1개, Private 1개)
aws_route_table_association: 4개 (각 서브넷과 라우팅 테이블 연결)
소계: 14개
2. 보안 그룹 (security.tf)
리소스 간의 네트워크 트래픽을 제어하는 방화벽 규칙을 정의합니다.

aws_security_group: 2개 (EKS 노드용, RDS용)
소계: 2개
3. 데이터베이스 (rds.tf)
Aurora PostgreSQL 데이터베이스 클러스터와 인스턴스를 생성합니다.

aws_db_subnet_group: 1개
aws_rds_cluster: 1개
aws_rds_cluster_instance: 1개
소계: 3개
4. EKS 클러스터 (eks.tf, compute.tf)
terraform-aws-modules/eks/aws 모듈을 사용하여 Kubernetes 클러스터를 구성합니다. 이 모듈은 내부적으로 여러 리소스를 생성합니다.

aws_eks_cluster: 1개
aws_eks_node_group: 2개 (ai_node_group, mugang_nodegroup)
aws_iam_role: 3개 (클러스터 제어 영역용 1개, 각 노드 그룹용 2개)
aws_launch_template: 2개 (각 노드 그룹용)
aws_security_group: 1개 (클러스터 제어 영역용)
aws_kms_key: 1개 (클러스터 암호화용)
aws_iam_openid_connect_provider: 1개 (IRSA 연동용)
이 외에도 다수의 aws_iam_role_policy_attachment, aws_security_group_rule 등 보조 리소스들이 함께 생성됩니다.
주요 리소스 소계: 약 11개
총 리소스 개수 요약
위 내역을 종합하면, 현재 프로젝트는 약 30개의 주요 AWS 리소스와 다수의 보조 리소스(IAM 정책 연결, 보안 그룹 규칙 등)를 생성하여 인프라를 구축하고 있습니다.