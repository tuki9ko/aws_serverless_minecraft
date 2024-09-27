terraform {
  backend "s3" {
    bucket         = "misha-minecraft-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
}