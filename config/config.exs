# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :heimdall,
  ecto_repos: [Heimdall.Repo]

# Configures the endpoint
config :heimdall, HeimdallWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nArEene8nvLcOwV9aa/BdqKRzNbsqMT9b6+sU6OOD6ECvK6TZMYXroL9/dMVOSam",
  render_errors: [view: HeimdallWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Heimdall.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :heimdall, HeimdallWeb.Guardian,
  issuer: "Heimdall",
  secret_key: "b2qcr*sNt%Q94XWy3IbHnQG^fhJ@qPM3C#f2!eXUZ%3hk&nWFtAnLVC3V4H4&zw2",
  # optional
  allowed_algos: ["HS256"],
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true

config :comeonin, :bcrypt_log_rounds, 4

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
