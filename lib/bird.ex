defmodule Bird do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      supervisor(Listings.Repo, []),
    ]

    IO.puts "Helllooo Bird"
    HTTPoison.start
    Bird.Scraper.scrape

    Supervisor.start_link children, strategy: :one_for_one
  end
end
