# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name = "nginx-example"
#     labels = {
#       app = "nginx"
#     }
#   }

#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         app = "nginx"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nginx"
#         }
#       }

#       spec {
#         container {
#           image = "nginx:latest"
#           name  = "nginx"

#           port {
#             container_port = 80
#           }
#           port {
#             container_port = 443
#           }
#         }
#       }
#     }
#   }
# }