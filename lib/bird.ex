defmodule Bird do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Listings.Repo, []),
      worker(Bird.Scraper, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Listings.Supervisor)
  end
end
