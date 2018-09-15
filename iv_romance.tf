variable "name" {
  default = "iv-romance"
}

resource "heroku_app" "iv_romance" {
  name         = "${var.name}"
  region       = "${var.heroku_region}"
  stack        = "${var.heroku_stack}"

  buildpacks = [
    "https://github.com/HashNuke/heroku-buildpack-elixir.git",
    "https://github.com/gjaldon/heroku-buildpack-phoenix-static.git",
    "https://github.com/einSelbst/heroku-buildpack-imagemagick"
  ]

  config_vars = {
    UPLOADS_S3_BUCKET = "${module.iv_romance_production_uploads.bucket_name}"
    AWS_ACCESS_KEY_ID = "${module.iv_romance_production_uploads.access_key_id}"
    AWS_SECRET_ACCESS_KEY = "${module.iv_romance_production_uploads.access_key_secret}"
  }
}

resource "heroku_addon" "iv_romance_database" {
  app  = "${heroku_app.iv_romance.name}"
  plan = "heroku-postgresql:hobby-dev"
}

module "iv_romance_production_uploads" {
  source = "./modules/bucket"

  environment = "production"
  resource_name = "${var.name}-uploads"
}

module "iv_romance_development_uploads" {
  source = "./modules/bucket"

  environment = "development"
  resource_name = "${var.name}-uploads"
}

output "iv_romance_development_uploads_bucket_name" {
  value = "${module.iv_romance_development_uploads.bucket_name}"
}

output "iv_romance_development_uploads_access_key_id" {
  value = "${module.iv_romance_development_uploads.access_key_id}"
}

output "iv_romance_development_uploads_access_key_secret" {
  value = "${module.iv_romance_development_uploads.access_key_secret}"
}
