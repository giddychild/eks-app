terraform {
  backend "s3" {
    bucket         = "seyi-eks-project"
    key            = "terraform/eks-application/state"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket         = "seyi-eks-project"
    key            = "terraform/eks-cluster/state"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "seyi-eks-project"
    key            = "terraform/eks-infrastructure/state"
    region         = "us-east-1"
  }
}
