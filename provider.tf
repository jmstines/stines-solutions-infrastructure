provider "aws" {
  alias  = "us_east_1"
  region = var.aws_region
}

provider "aws" {
  region = var.aws_region
}
