- 前提

Mac

Docker for Mac をインストールしてKubernetesを有効化

kubectlの向き先がdocker-desktopになっていること
```
$ kubectl config get-contexts
```


- サービスアカウント作成
```
$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```
トークン表示
```
$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```

- ダッシュボードUIインストール

```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
$ kubectl proxy
```

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.





- ref

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

https://matsuand.github.io/docs.docker.jp.onthefly/desktop/kubernetes/
