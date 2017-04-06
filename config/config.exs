use Mix.Config

config :bird, Listings.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bird_repo",
  username: "birdie",
  password: "pass",
  hostname: if (Mix.env == :prod), do: "db", else: "localhost"

config :bird, ecto_repos: [Listings.Repo]

config :bird,
  slack_token: System.get_env("SLACK_TOKEN"),
  slack_channel: "general",
  bot_name: "bird_bot",
  icon_url: "https://ca.slack-edge.com/T4P3WSD33-U4P9K23TK-16c837768aa8-512",
  craigslist_url: "https://sfbay.craigslist.org",
  min_price: 500,
  max_price: 1200,
  neighborhoods: [7,9,13,14,15,18,21,26,28,2,114]
