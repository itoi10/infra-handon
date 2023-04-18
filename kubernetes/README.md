- Mac環境設定

Docker for Mac でk8s有効化

kubectl設定


- ダッシュボードUIインストール

```
kubectl get deployment kubernetes-dashboard -n kubernetes-dashboard -o yaml > dashboard.yaml
```
dashboard.yamlの38行目に```- --enable-skip-login``` 追加
```
kubectl apply -f dashboard.yaml
kubectl proxy
```
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Skipクリック

