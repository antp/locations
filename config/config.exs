# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :locations,
  ecto_repos: [Locations.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :locations, LocationsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HXBVd2yoFLS1y6x9dtppYpk78djR9Z5I76zgmorVwu1V+cVnhKNIEDU9bLsggiTx",
  render_errors: [view: LocationsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Locations.PubSub,
  live_view: [signing_salt: "V8+crukO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :geo_postgis,
  json_library: Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
