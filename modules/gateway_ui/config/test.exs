import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hm_gateway_ui, HmGatewayUiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lDhMw5ev8xFVwUp5OPlwyos2WnZ4G302wF0i8xsZwsB9wNSmloDxy10IoUKqj5U1",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
