# 時間単位で料金がかかるサービス

#----------------------------------------------------------------
# VPCエンドポイント
#----------------------------------------------------------------
# インターフェース型は各AZで1時間ごとに0.014USD
# ゲートウェイ型は無料

# # ecr.api
# resource "aws_vpc_endpoint" "sbcntrVpceEcrApi" {
#   # インターフェース型
#   vpc_endpoint_type = "Interface"
#   # ecr.api
#   service_name = "com.amazonaws.ap-northeast-1.ecr.api"
#   # 作成済みのVPC
#   vpc_id = aws_vpc.sbcntrVpc.id
#   # 1aと1cのAZでそれぞれ'egress'が付くサブネットを選択
#   subnet_ids = [
#     aws_subnet.sbcntrSubnetPrivateEgress1A.id,
#     aws_subnet.sbcntrSubnetPrivateEgress1C.id
#   ]
#   # プライベートDNS名を有効にする
#   private_dns_enabled = true
#   # egressのSGを選択
#   security_group_ids = [
#     aws_security_group.sbcntrSgIngress.id
#   ]
#   # ポリシーはフルアクセスがデフォルト

#   # 名称設定にはNameタグを使用する
#   tags = {
#     Name = "sbcntr-vpce-ecr-api"
#   }
# }

# # ecr.dkr
# resource "aws_vpc_endpoint" "sbcntrVpceEcrDkr" {
#   vpc_endpoint_type = "Interface"
#   # ecr.dkr
#   service_name = "com.amazonaws.ap-northeast-1.ecr.dkr"
#   vpc_id       = aws_vpc.sbcntrVpc.id
#   subnet_ids = [
#     aws_subnet.sbcntrSubnetPrivateEgress1A.id,
#     aws_subnet.sbcntrSubnetPrivateEgress1C.id
#   ]
#   private_dns_enabled = true
#   security_group_ids = [
#     aws_security_group.sbcntrSgIngress.id
#   ]
#   tags = {
#     Name = "sbcntr-vpce-ecr-api"
#   }
# }

# # CloudWatch Logs用
# resource "aws_vpc_endpoint" "sbcntrVpceLogs" {
#   vpc_endpoint_type = "Interface"
#   # logs
#   service_name = "com.amazonaws.ap-northeast-1.logs"
#   vpc_id       = aws_vpc.sbcntrVpc.id
#   subnet_ids = [
#     aws_subnet.sbcntrSubnetPrivateEgress1A.id,
#     aws_subnet.sbcntrSubnetPrivateEgress1C.id
#   ]
#   private_dns_enabled = true
#   security_group_ids = [
#     aws_security_group.sbcntrSgIngress.id
#   ]
#   tags = {
#     Name = "sbcntr-vpce-logs"
#   }
# }

# S3
resource "aws_vpc_endpoint" "sbcntrVpceS3" {
  # ゲートウェイ型
  vpc_endpoint_type = "Gateway"
  # s3
  service_name = "com.amazonaws.ap-northeast-1.s3"
  vpc_id       = aws_vpc.sbcntrVpc.id
  # コンテナアプリ用のルートテーブル
  route_table_ids = [
    aws_route_table.sbcntrRouteApp.id
  ]
  tags = {
    Name = "sbcntr-vpce-s3"
  }
}

#----------------------------------------------------------------
# ALB
#----------------------------------------------------------------
# 時間（または1時間未満）あたり、0.0243USD
# LCU時間（または1時間未満）あたり、0.008USD

# 内部用ロードバランサ
resource "aws_lb" "sbcntrAlbInternal" {
  name = "sbcntr-alb-internal"
  # 内部向け
  internal = true
  # ALB
  load_balancer_type = "application"
  subnets = [
    aws_subnet.sbcntrSubnetPrivateContainer1A.id,
    aws_subnet.sbcntrSubnetPrivateContainer1C.id
  ]
  security_groups = [
    aws_security_group.sbcntrSgInternal.id
  ]
}

# TerraformでALBを作成する
# https://qiita.com/gogo-muscle/items/81d9f73f16f901d95424

# ターゲットグループ (Blue)
resource "aws_lb_target_group" "sbcntrTgSbcntrdemoBlue" {
  name = "sbcntr-tg-sbcntrdemo-blue"
  # ターゲットの種類
  target_type = "ip"
  # VPC
  vpc_id = aws_vpc.sbcntrVpc.id
  # プロトコル
  protocol = "HTTP"
  # ポート
  port = 80
  # プロトコルバージョン
  protocol_version = "HTTP1"
  # ヘルスチェック
  health_check {
    # プロトコル
    protocol = "HTTP"
    # パス
    path = "/healthcheck"
    # ポート
    port = "traffic-port"
    # 正常のしきい値
    healthy_threshold = 3
    # 非正常のしきい値
    unhealthy_threshold = 2
    # タイムアウト
    timeout = 5
    # 間隔
    interval = 15
    # 成功コード
    matcher = 200
  }
}

# リスナー
resource "aws_lb_listener" "sbcntrListenerBlue" {
  load_balancer_arn = aws_lb.sbcntrAlbInternal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbcntrTgSbcntrdemoBlue.arn
  }
}


