resource "kubernetes_service_account" "alb-ingress" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.service_account_arn
    }
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  automount_service_account_token = "true"
}

resource "kubernetes_cluster_role" "cluter_role" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "configmaps",
      "endpoints",
      "events",
      "ingresses",
      "ingresses/status",
      "services",
    ]

    verbs = [
      "create",
      "get",
      "list",
      "update",
      "watch",
      "patch",
    ]
  }
  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "nodes",
      "pods",
      "secrets",
      "services",
      "namespaces",
    ]

    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_role_bind" {
  metadata {
    name = "alb-ingress-controller"

    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    name      = kubernetes_cluster_role.cluter_role.metadata[0].name
    kind      = "ClusterRole"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.alb-ingress.metadata[0].name
    namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "alb-ingress-controller"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "alb-ingress-controller"
        }
      }

      spec {
        automount_service_account_token = true
        service_account_name            = kubernetes_service_account.alb-ingress.metadata[0].name
        container {
          name              = "alb-ingress-controller"
          image             = format("docker.io/amazon/aws-alb-ingress-controller:v1.1.4")
          image_pull_policy = "Always"
          args = [
            format("--ingress-class=alb"),
            format("--cluster-name=%s", var.cluster_name),
            format("--aws-vpc-id=%s", var.vpcid),
            format("--aws-region=%s", var.region),
          ]
        }
      }
    }
  }
}

resource "kubernetes_ingress" "rules" {
  metadata {
    name      = "insights-alb"
    namespace = var.app_namespace
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/target-type" = "instance"
      "alb.ingress.kubernetes.io/subnets"     = join(", ", var.subnet_ids_list)
    }
    labels = {
      app = "insights-alb"
    }
  }
  spec {
    rule {

      http {
        path {
          backend {
            service_name = var.service_name
            service_port = var.service_port
          }
          path = "/*"
        }
      }
    }
  }

}

output "ingress_hostname" {
  value       = kubernetes_ingress.rules.load_balancer_ingress
  description = ""
}

##############################################################################
#       Below pods are for testing 
#
#############################################################################
resource "kubernetes_service" "example" {
  metadata {
    name = var.service_name
  }
  spec {
    selector = {
      app = "${kubernetes_pod.example.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port        = var.service_port
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_pod" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      app = "MyApp"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"
    }
  }
}