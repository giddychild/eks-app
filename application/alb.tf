# apiVersion: v1
# kind: Service
# metadata:
#   name: color-service
#   annotations:
#     service.beta.kubernetes.io/aws-load-balancer-type: "external"
#     service.beta.kubernetes.io/aws-load-balancer-name: "eks-alb"
#     service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
#     service.beta.kubernetes.io/aws-load-balancer-ssl-cert: var.ssl_cert_arn
#     service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
#     service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
# spec:
#   selector:
#     app: "color"
#     color: "blue" # Optional: Include if you specifically want to target only blue versions
#   type: LoadBalancer
#   ports:
#     - protocol: TCP
#       port: 443
#       targetPort: 8080


  
resource "aws_lb" "eks_alb" {
  name               = "eks-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  enable_deletion_protection = false

  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.eks_alb.arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target_group.arn
  }
}

resource "aws_lb_target_group" "eks_target_group" {
  name     = "eks-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = "80"
    interval = 30
    timeout  = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}