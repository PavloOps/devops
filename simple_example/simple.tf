terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_vpc_network" "kubernetes" {
  name = "kubernetes"
}

resource "yandex_vpc_subnet" "kubernetes" {
  name = "kubernetes"

  network_id     = yandex_vpc_network.kubernetes.id
  v4_cidr_blocks = ["10.0.0.0/16"]
}

locals {
  folder_id   = "b1gv2oh472eqbr5sbdoo"
}

resource "yandex_iam_service_account" "myaccount" {
  name = "zonal-k8s-account"
  description = "K8S zonal service account"
}
data "yandex_client_config" "client" {}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = local.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = local.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = local.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
  folder_id = local.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

module "kubernetes" {
  source = "sport24ru/managed-kubernetes/yandex"
  service_account_id = yandex_iam_service_account.myaccount.id
  name       = "simple-zonal-cluster"
  folder_id  = data.yandex_client_config.client.folder_id
  network_id = yandex_vpc_subnet.kubernetes.network_id

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
  master_locations = [{
    subnet_id = yandex_vpc_subnet.kubernetes.id
    zone      = yandex_vpc_subnet.kubernetes.zone
  }]

#  service_account_name = "k8s-manager"

  node_groups = {
    default = {
      fixed_scale = {
        size = 2
      }
    }
  }
}
