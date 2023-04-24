- k8sクラスタ作成
gcloud container clusters create mycluster --cluster-version=1.24.10-gke.2300 --machine-type=n1-standard-1 --num-nodes=3

- クラスタを生業できるようにkubectlに認証情報設定
gcloud container clusters get-credentials mycluster
