# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :higherlower_osu,
  ecto_repos: [HigherlowerOsu.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :higherlower_osu, HigherlowerOsuWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "3T4UQW9x8vN+8POUi4vjkR9M07BXEweBIoiKFDgcFrZ7XTCJIQu1UOrc6U//Gco5",
  render_errors: [
    formats: [html: HigherlowerOsuWeb.ErrorHTML, json: HigherlowerOsuWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: HigherlowerOsu.PubSub,
  live_view: [signing_salt: "OPmg1ruT"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :higherlower_osu, HigherlowerOsu.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  higherlower_osu: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  higherlower_osu: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
