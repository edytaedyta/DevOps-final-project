resource "kubernetes_namespace" "this" {
  metadata { name = var.namespace }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  values     = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.this]
}

data "kubernetes_secret" "initial" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.namespace
  }

  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "django-app"
      namespace = var.namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.charts_repo_url
        targetRevision = var.git_repository_branch
        path           = var.charts_repo_path
        helm = {
          parameters = [
            {
              name  = "image.repository"
              value = var.ecr_repository_url
            },
            {
              name  = "image.tag"
              value = var.image_tag
            },
            {
              name  = "env.DB_HOST"
              value = var.db_host
            },
            {
              name  = "env.DB_PORT"
              value = var.db_port
            },
            {
              name  = "env.DB_NAME"
              value = var.db_name
            },
            {
              name  = "env.DB_USER"
              value = var.db_user
            },
            {
              name  = "env.DB_PASSWORD"
              value = var.db_password
            }
          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }

  depends_on = [helm_release.argocd]
}
