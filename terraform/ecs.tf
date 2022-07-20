#----------------------------------------------------------------
# ECR
#----------------------------------------------------------------
# フロントアプリ用
resource "aws_ecr_repository" "sbcntrEcrFrontend" {
  name                 = "sbcntr-frontend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}

# バックアプリ用
resource "aws_ecr_repository" "sbcntrEcrbackend" {
  name                 = "sbcntr-backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}
