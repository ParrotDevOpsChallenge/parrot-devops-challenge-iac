terraform {
  backend "s3" {
    bucket         = "parrot-devops-challenge-iac"
    key            = "code"
    region         = "us-west-2"
  }
}