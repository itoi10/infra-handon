#----------------------------------------------------------------
# VPC
#----------------------------------------------------------------
resource "aws_vpc" "sbcntrVpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "sbcntrVpc"
  }
}

#----------------------------------------------------------------
# Subnet, RouteTable, RouteTableAssociation
#----------------------------------------------------------------
#--------------------------------
# コンテナアプリ用　(Private)
#--------------------------------
## コンテナアプリ用のプライベートサブネット
# プライベートサブネット1A
resource "aws_subnet" "sbcntrSubnetPrivateContainer1A" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1a"
    Type = "Isolated"
  }
}

# プライベートサブネット1C
resource "aws_subnet" "sbcntrSubnetPrivateContainer1C" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.9.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1c"
    Type = "Isolated"
  }
}

## コンテナアプリ用のルートテーブル
resource "aws_route_table" "sbcntrRouteApp" {
  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-route-app"
  }
}

## コンテナサブネットへルート紐付け
# サブネットとルートテーブルを関連付ける
resource "aws_route_table_association" "sbcntrRouteAppAssociation1A" {
  route_table_id = aws_route_table.sbcntrRouteApp.id
  subnet_id      = aws_subnet.sbcntrSubnetPrivateContainer1A.id
}

resource "aws_route_table_association" "sbcntrRouteAppAssociation1C" {
  route_table_id = aws_route_table.sbcntrRouteApp.id
  subnet_id      = aws_subnet.sbcntrSubnetPrivateContainer1C.id
}

#--------------------------------
# DB周りの設定 (Private)
#--------------------------------
## DB用のプライベートサブネット
resource "aws_subnet" "sbcntrSubnetPrivateDb1A" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.16.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-db-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntrSubnetPrivateDb1C" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.17.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-db-1c"
    Type = "Isolated"
  }
}

## DB用のルートテーブル
resource "aws_route_table" "sbcntrRouteDb" {
  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-route-db"
  }
}

## DBサブネットへルート紐付け
resource "aws_route_table_association" "sbcntrRouteDbAssociation1A" {
  route_table_id = aws_route_table.sbcntrRouteDb.id
  subnet_id      = aws_subnet.sbcntrSubnetPrivateDb1A.id
}

resource "aws_route_table_association" "sbcntrRouteDbAssociation1C" {
  route_table_id = aws_route_table.sbcntrRouteDb.id
  subnet_id      = aws_subnet.sbcntrSubnetPrivateDb1C.id
}

#--------------------------------
# Ingress周りの設定 (Public)
#--------------------------------
## Ingress用のパブリックサブネット
resource "aws_subnet" "sbcntrSubnetPublicIngress1A" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true #　このサブネットで起動したインスタンスがパブリックIPv4アドレスを受信する
  tags = {
    Name = "sbcntr-subnet-private-container-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntrSubnetPublicIngress1C" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true #　このサブネットで起動したインスタンスがパブリックIPv4アドレスを受信する
  tags = {
    Name = "sbcntr-subnet-private-container-1c"
    Type = "Isolated"
  }
}

## Ingress用のルートテーブル
resource "aws_route_table" "sbcntrRouteIngress" {
  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-route-ingress"
  }
}

## Ingressサブネットへルート紐付け
resource "aws_route_table_association" "sbcntrRouteIngressAssociation1A" {
  route_table_id = aws_route_table.sbcntrRouteIngress.id
  subnet_id      = aws_subnet.sbcntrSubnetPublicIngress1A.id
}

resource "aws_route_table_association" "sbcntrRouteIngressAssociation1C" {
  route_table_id = aws_route_table.sbcntrRouteIngress.id
  subnet_id      = aws_subnet.sbcntrSubnetPublicIngress1C.id
}

## Ingress用ルートテーブルのデフォルトルート
resource "aws_route" "sbcntrRouteIngressDefault" {
  route_table_id         = aws_route_table.sbcntrRouteIngress.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sbcntrIgw.id
  depends_on = [
    aws_internet_gateway_attachment.sbcntrVpcgwAttachment
  ]
}

#--------------------------------
# 管理用サーバ周りの設定
#--------------------------------
## 管理用のパブリックサブネット
resource "aws_subnet" "sbcntrSubnetPublicManagement1A" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.240.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true #　このサブネットで起動したインスタンスがパブリックIPv4アドレスを受信する
  tags = {
    Name = "sbcntr-subnet-public-management-1a"
    Type = "Public"
  }
}

resource "aws_subnet" "sbcntrSubnetPublicManagement1C" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.241.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true #　このサブネットで起動したインスタンスがパブリックIPv4アドレスを受信する
  tags = {
    Name = "sbcntr-subnet-public-management-1c"
    Type = "Public"
  }
}

## 管理用サブネットのルートはIngressと同様として作成する
resource "aws_route_table_association" "sbcntrRouteManagementAssociation1A" {
  route_table_id = aws_route_table.sbcntrRouteIngress.id
  subnet_id      = aws_subnet.sbcntrSubnetPublicManagement1A.id
}

resource "aws_route_table_association" "sbcntrRouteManagementAssociation1C" {
  route_table_id = aws_route_table.sbcntrRouteIngress.id
  subnet_id      = aws_subnet.sbcntrSubnetPublicManagement1C.id
}

#--------------------------------
# VPCエンドポイント周りの設定
#--------------------------------
## VPCエンドポイント(Egress通信)用のプライベートサブネット
resource "aws_subnet" "sbcntrSubnetPrivateEgress1A" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.248.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-egress-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntrSubnetPrivateEgress1C" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.249.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-egress-1c"
    Type = "Isolated"
  }
}

#----------------------------------------------------------------
# InternetGateway
#----------------------------------------------------------------

# インターネットへ通信するためのゲートウェイの作成
resource "aws_internet_gateway" "sbcntrIgw" {
  tags = {
    Name = "sbcntr-igw"
  }
}

# IGWをVPCにアタッチしインターネットとVPC間の通信を可能にする
resource "aws_internet_gateway_attachment" "sbcntrVpcgwAttachment" {
  vpc_id              = aws_vpc.sbcntrVpc.id
  internet_gateway_id = aws_internet_gateway.sbcntrIgw.id
}

#----------------------------------------------------------------
# SecurityGroup, SecurityGroupRule
#----------------------------------------------------------------

# セキュリティグループの生成
## インターネット公開のセキュリティグループの生成
resource "aws_security_group" "sbcntrSgIngress" {
  name        = "ingress"
  description = "Security group for ingress"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic by default"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "from 0.0.0.0/0:80"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  ingress {
    ipv6_cidr_blocks = ["::/0"]
    description      = "from ::/0:80"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
  }

  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-sg-ingress"
  }
}

## 管理用サーバ向けのセキュリティグループの生成
resource "aws_security_group" "sbcntrSgManagement" {
  name        = "management"
  description = "Security Group of management server"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic by default"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-sg-management"
  }
}

## バックエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "sbcntrSgContainer" {
  name        = "container"
  description = "Security Group of backend app"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic by default"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-sg-container"
  }
}

## フロントエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "sbcntrSgFrontContainer" {
  name        = "front-container"
  description = "Security Group of front container app"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic by default"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-sg-front-container"
  }
}

## 内部用ロードバランサ用のセキュリティグループの生成
resource "aws_security_group" "sbcntrSgInternal" {
  name        = "internal"
  description = "Security group for internal load balancer"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic by default"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-sg-internal"
  }
}

## DB用セキュリティグループの生成
resource "aws_security_group" "sbcntrSgDb" {
  name        = "database"
  description = "Security Group of database"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic by default"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-sg-db"
  }
}

## VPCエンドポイント用セキュリティグループの生成
resource "aws_security_group" "sbcntrSgEgress" {
  name        = "egress"
  description = "Security Group of VPC Endpoint"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic by default"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  vpc_id = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-sg-vpce"
  }
}


# ルール紐付け
## Internet LB -> Front Container
resource "aws_security_group_rule" "sbcntrSgFrontContainerFromsSgIngress" {
  type                     = "ingress"
  description              = "HTTP for Ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgFrontContainer.id
  source_security_group_id = aws_security_group.sbcntrSgIngress.id
}

## Front Container -> Internal LB
resource "aws_security_group_rule" "sbcntrSgInternalFromSgFrontContainer" {
  type                     = "ingress"
  description              = "HTTP for front container"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgInternal.id
  source_security_group_id = aws_security_group.sbcntrSgFrontContainer.id
}

## Internal LB -> Back Container
resource "aws_security_group_rule" "sbcntrSgContainerFromSgInternal" {
  type                     = "ingress"
  description              = "HTTP for internal lb"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgContainer.id
  source_security_group_id = aws_security_group.sbcntrSgInternal.id
}

## Back container -> DB
resource "aws_security_group_rule" "sbcntrSgDbFromSgContainerTCP" {
  type                     = "ingress"
  description              = "MySQL protocol from backend App"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgDb.id
  source_security_group_id = aws_security_group.sbcntrSgContainer.id
}

## Front container -> DB
resource "aws_security_group_rule" "sbcntrSgDbFromSgFrontContainerTCP" {
  type                     = "ingress"
  description              = "MySQL protocol from frontend App"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgDb.id
  source_security_group_id = aws_security_group.sbcntrSgFrontContainer.id
}

## Management server -> DB
resource "aws_security_group_rule" "sbcntrSgDbFromSgManagementTCP" {
  type                     = "ingress"
  description              = "MySQL protocol from management server"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgDb.id
  source_security_group_id = aws_security_group.sbcntrSgManagement.id
}

## Management server -> Internal LB
resource "aws_security_group_rule" "sbcntrSgInternalFromSgManagementTCP" {
  type                     = "ingress"
  description              = "HTTP for management server"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgInternal.id
  source_security_group_id = aws_security_group.sbcntrSgManagement.id
}

### Back container -> VPC endpoint
resource "aws_security_group_rule" "sbcntrSgVpceFromSgContainerTCP" {
  type                     = "ingress"
  description              = "HTTPS for Container App"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgEgress.id
  source_security_group_id = aws_security_group.sbcntrSgContainer.id
}

### Front container -> VPC endpoint
resource "aws_security_group_rule" "sbcntrSgVpceFromSgFrontContainerTCP" {
  type                     = "ingress"
  description              = "HTTPS for Front Container App"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgEgress.id
  source_security_group_id = aws_security_group.sbcntrSgFrontContainer.id
}

### Management Server -> VPC endpoint
resource "aws_security_group_rule" "sbcntrSgVpceFromSgManagementTCP" {
  type                     = "ingress"
  description              = "HTTPS for management server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sbcntrSgEgress.id
  source_security_group_id = aws_security_group.sbcntrSgManagement.id
}
