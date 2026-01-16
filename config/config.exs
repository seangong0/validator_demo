# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :validator_demo,
  ecto_repos: [ValidatorDemo.Repo],
  generators: [timestamp_type: :utc_datetime_usec]

config :validator_demo, ValidatorDemo.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [column: :id, type: :binary_id],
  migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :validator_demo, ValidatorDemoWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: ValidatorDemoWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ValidatorDemo.PubSub,
  live_view: [signing_salt: "AWQ_5ISxoog"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
env = config_env()

if "#{env}.exs" |> Path.expand(__DIR__) |> File.exists?() do
  import_config "#{env}.exs"

  if "#{env}.secret.exs" |> Path.expand(__DIR__) |> File.exists?() do
    import_config "#{env}.secret.exs"
  end
end
