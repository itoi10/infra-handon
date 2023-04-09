// Terraform version
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

variable "project_name" {
  type    = string
  default = "my-project"
}

// Provider
provider "google" {
  // サービスアカウントの認証情報
  credentials = file("credentials.json")
  // プロジェクト名
  project = var.project_name
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}


// VPC
resource "google_compute_network" "vpc_network" {
  # リソース名
  name = "my-custom-mode-network"
  // trueだと各リージョンのサブネットが自動作成される. falseだと手動で作成する
  auto_create_subnetworks = false
  // 最大伝送単位(bytes) デフォルト1460
  mtu = 1460
}

// Subnet
resource "google_compute_subnetwork" "default" {
  # リソース名
  name = "my-custom-subnet"
  # IPアドレス範囲 (IPv4)
  ip_cidr_range = "10.0.1.0/24"
  # GCPリージョン
  region = "asia-northeast1"
  # 所属するネットワーク
  network = google_compute_network.vpc_network.id
}


// Compute Engine
resource "google_compute_instance" "default" {
  // リソース名
  name = "flask-vm"
  // マシンタイプ
  machine_type = "e2-micro"
  // ゾーン. 指定がない場合はproviderのzoneが使用される
  zone = "asia-northeast1-a"
  // ネットワークタグ
  tags = ["ssh"]

  // インスタンスのブートディスク
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Flaskをpipインストール
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  // インスタンスにアタッチするネットワーク
  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    // インスタンスがインターネット経由でアクセスできるIP
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
