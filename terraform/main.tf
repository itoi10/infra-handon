# ProviderとしてAWSを設定
provider "aws" {
  region = "ap-northeast-1"

  # 全てのリソースに一括で共通のタグを付けられる (aws3.38以降)
  default_tags {
    tags = {
      template = "terraform"
    }
  }
}

# tfstateをs3に保存する
terraform {
  # tfのバージョン制約
  required_version = "1.2.5"

  # Providerのバージョン制約
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }

  # tfstateの保存先をS3に設定
  backend "s3" {
    bucket = "mytfstate110"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}

# VPC
resource "aws_vpc" "sbcntrVpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "sbcntrVpc"
  }
}

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


# DB周りの設定
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


# Ingress周りの設定
## Ingress用のパブリックサブネット
resource "aws_subnet" "sbcntrSubnetPublicIngress1A" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true #　このサブネットで起動したインスタンンスがパブリックIPv4アドレスを受信する
  tags = {
    Name = "sbcntr-subnet-private-container-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntrSubnetPublicIngress1C" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true #　このサブネットで起動したインスタンンスがパブリックIPv4アドレスを受信する
  tags = {
    Name = "sbcntr-subnet-private-container-1c"
    Type = "Isolated"
  }
}
