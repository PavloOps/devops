```
helm install ingress-nginx ingress-nginx/ingress-nginx --values values.yaml
```

```commandline
helm uninstall ingress-nginx
```

```
yc iam service-account create --name pavloops
```
id: aje3ai8jei4j5aff9v2f
folder_id: b1gv2oh472eqbr5sbdoo
created_at: "2024-02-10T11:15:50.733015566Z"
name: pavloops

```
yc iam service-account list
```
+----------------------+--------------------+
|          ID          |        NAME        |
+----------------------+--------------------+
| aje6i0f3n6ovfbtf5fle | pavloops           |
| ajeln2h9b7hr03mfe40r | k8s-node-group-2mt |
| ajepj0aaal3evf788tit | k8s-cluster-bnz    |
+----------------------+--------------------+


```commandline
yc iam key create \
  --service-account-id aje3ai8jei4j5aff9v2f \
  --folder-name default \
  --output key.json
```

id: aje16hnalttli7548dhj
service_account_id: aje3ai8jei4j5aff9v2f
created_at: "2024-02-10T12:08:58.881807325Z"
key_algorithm: RSA_2048

```
yc config profile create terraform
```

```commandline
yc config set service-account-key key.json
yc config set cloud-id b1gr3rdta4750j58lh9s
yc config set folder-id b1gv2oh472eqbr5sbdoo
```

```commandline
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_ZONE=$(yc config get compute-default-zone)
```

    YC_TOKEN — IAM-токен.
    YC_CLOUD_ID — идентификатор облака.
    YC_FOLDER_ID — идентификатор каталога.

```commandline
terraform destroy
```

unbordered.world

```commandline
kubectl create ns traefik
```

```commandline
helm upgrade --install traefik traefik/traefik --namespace traefik --values config/traefik.yaml --version 25.0.0
```

=)
=)