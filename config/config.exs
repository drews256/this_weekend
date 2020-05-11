use Mix.Config

config :this_weekend, PointingParty.Repo,
  database: "where_to",
  username: "postgres",
  hostname: "localhost"

config :this_weekend,
  ecto_repos: [PointingParty.Repo]

# Configures the endpoint
config :this_weekend, PointingPartyWeb.Endpoint,
  live_view: [signing_salt: "SECRET_SALT"],
  url: [host: "localhost"],
  secret_key_base: "w1I+WClCAIRKxSX5/M7gFHQLa9pnn4AuVDO6XmUgTZxJl+VqMOr2Q5Ou+2CSoLdJ",
  render_errors: [view: PointingPartyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PointingParty.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

import_config "cards.exs"

config :geocoder, :worker_pool_config, size: 4, max_overflow: 2

config :geocoder, :worker,
  # OpenStreetMaps or OpenCageData are other supported providers
  provider: Geocoder.Providers.OpenStreetMaps

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
