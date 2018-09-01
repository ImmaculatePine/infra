resource "heroku_app" "iv_romance" {
  name         = "iv-romance"
  region       = "${var.heroku_region}"
  stack        = "${var.heroku_stack}"

  buildpacks = [
    "https://github.com/HashNuke/heroku-buildpack-elixir.git",
    "https://github.com/gjaldon/heroku-buildpack-phoenix-static.git"
  ]
}

resource "heroku_addon" "iv_romance_database" {
  app  = "${heroku_app.iv_romance.name}"
  plan = "heroku-postgresql:hobby-dev"
}
