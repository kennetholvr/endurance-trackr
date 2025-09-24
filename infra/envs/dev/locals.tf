locals {
  app         = "ff"
  env         = var.env                     # "dev"
  name_prefix = "${local.app}-${local.env}" # e.g., "ff-dev"
}