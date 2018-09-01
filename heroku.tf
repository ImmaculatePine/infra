variable "heroku_email" {}

variable "heroku_api_key" {}

variable "heroku_region" {
  default = "eu"
}

variable "heroku_stack" {
  default = "heroku-16"
}

provider "heroku" {
  email   = "${var.heroku_email}"
  api_key = "${var.heroku_api_key}"

  version = "~> 1.3"
}
