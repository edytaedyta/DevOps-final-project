resource "kubernetes_namespace" "this" {
  metadata { name = var.namespace }
}

resource "kubernetes_secret" "ci_env" {
  metadata {
    name      = "ci-env"
    namespace = var.namespace
  }

  data = {
    AWS_REGION            = var.aws_region
    ECR_REPOSITORY_URL    = var.ecr_repository_url
    GIT_REPOSITORY_URL    = var.git_repository_url
    GIT_REPOSITORY_BRANCH = var.git_repository_branch
    GIT_USERNAME          = var.git_username
    GIT_TOKEN             = var.git_token
  }

  type = "Opaque"
  depends_on = [kubernetes_namespace.this]
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = var.namespace
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version
  values     = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.this]
}

data "kubernetes_secret" "admin" {
  metadata {
    name      = "jenkins"
    namespace = var.namespace
  }

  depends_on = [helm_release.jenkins]
}
