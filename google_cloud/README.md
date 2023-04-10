# Google Cloud Terraform

## 起動

- main.tfのproject_nameとcredentialsを設定してterraform apply

- WebコンソールからCompute EngineにSSH接続しFlask起動
  - vi app.py でapp.pyファイル作成
  - pip3 install flask でFlaskインストール
  - python3 app.py でFlaskサーバ起動

- terraform OutPutsのURLで外部からアクセスできる

- terraform destroy で片付け
