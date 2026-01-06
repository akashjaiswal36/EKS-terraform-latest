terraform {
    backend "s3" {
        bucket = "eks-terraform-latest-s3-backend-tf-060126"
        key = "dev/eks/terraform.tfstate"
        region = "ap-south-1"
        dynamodb_table = "terraform-locks-eks"
        encrypt =  true
    }
}