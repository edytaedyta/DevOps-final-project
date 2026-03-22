resource "random_password" "grafana" {
  length  = 20
  special = false
}

resource "kubernetes_namespace" "this" {
  metadata { name = var.namespace }
}

resource "helm_release" "kps" {
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [templatefile("${path.module}/values.yaml", {
    grafana_admin_password = random_password.grafana.result
  })]

  depends_on = [kubernetes_namespace.this]
}
