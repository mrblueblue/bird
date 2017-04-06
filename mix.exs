defmodule Bird.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bird,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
   ]
  end

  def application do
    [
      mod: {Bird, []},
      applications: [
        :logger,
        :httpoison,
        :floki,
        :timex,
        :ecto,
        :postgrex
      ]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.10.0"},
      {:floki, "~> 0.14.0"},
      {:timex, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:distillery, "~> 0.9"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
