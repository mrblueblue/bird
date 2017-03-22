defmodule Bird do
  use Application

  def start(_type, _args) do
    IO.puts "Helllooo Bird"
    HTTPoison.start
    Bird.Scraper.scrape
    Supervisor.start_link [], strategy: :one_for_one
  end
end
