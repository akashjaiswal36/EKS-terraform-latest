variable "region" {
  type    = string
  default = "ap-south-1"
}


variable "name" {
    type = string
    default = "eks-terraform"
}

variable "eks_version" {
    type = string 
    default = "1.33"

    validation {
        condition     = contains(["1.32", "1.33"], var.eks_version)
        error_message = "Only AWS-supported EKS versions are allowed."
    }
}


variable "vpc_cidr" {
    type = string
    default = "10.30.0.0/16"
}

variable "tags" {
    type = map(string)
    default = {
        Project = "eks-terraform-latest"
        Env = "test"
        ManagedBy = "terraform"
    }
}