terraform {
  backend "s3" {
    bucket       = "fitstate"
    key          = "envs/dev/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }
}