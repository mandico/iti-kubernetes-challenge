
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-itau-cluster"
  }
}

resource "helm_release" "kotlin_app" {
  name       = "kotlin-app"
  chart      = "../Chart/app"
  namespace  = "default"

  set {
    name  = "image.repository"
    value = "kotlin-app"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "image.pullPolicy"
    value = "Never"
  }

  set {
    name  = "service.port"
    value = 8080
  }
}