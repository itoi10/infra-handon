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
