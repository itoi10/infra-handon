インフラAWS

メモ

aws-container

- tf version

  1.2.5

- tfコマンド

  plan, apply, destroy, state list, state show (rs), state pull


serverless

chaliecはAWS LambdaでサーバレスアプリをPythonで構築するためのAmazon公式フレームワーク


- 新規作成  chalice new-project <name>
- デプロイ  chalice deploy --stage prod     
- 削除     chalice delete --stage prod
- ローカル  chalice local --stage dev --port 8000

chalicelibディレクトリ以下はapp.pyと合わせてAWSにデプロイされる

DBはDynamoDB
Lamdbaはリクエスト毎に別々のコンテナで実行されRDSを使った場合、それぞれにコネクションが張られるので同時リクエスト数が増えるとRDSでは限界が来る。
DynamoDBは分散型KeyValueストアで、アクセスが増えてもスケーリングで対応できる。

- テーブル作成 aws dynamodb create-table --cli-input-json file://schema.json
- 初期データ登録 aws dynamodb batch-write-item --request-items file://initial-data.json

WebAPI使用
- GET /todos 全取得
- GET /todos/{todo_id} 取得
- POST /todos 登録
- PUT /todos/{todos_id} 更新
- DELETE /todos/{todo_id} 削除

policy-prod.json

Lamdba関数にDynamoDBにアクセスするためのIAMロールを割り当てる。
boto3.clientならデプロイ時に自動で必要なIAMロールを作成されるがboto3.resourceは対応していない。

CORS対応
@app.routeの引数に cors=True を追加すればAccess-Control-Allow-Origin: *　になる


起動方法(ローカル)
- ローカル用DynamoDB
  ```java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb -port 8001```
- backend
  ```chalice local --stage dev --port 8000```
- frontend
  ```python -m http.server 8002```

参考

- aws-container
[AWSコンテナ設計・構築［本格］入門](https://www.amazon.co.jp/dp/B09DKZC1ZH/)


- serverless
[ほぼPythonだけでサーバーレスアプリをつくろう](https://www.amazon.co.jp/dp/B07X2CTF48/)