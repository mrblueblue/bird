defmodule Bird.ReleaseTasks do
  @start_apps [
    :postgrex,
    :ecto
  ]

  @myapps [
    :bird
  ]

  @repos [
    Listings.Repo
  ]

  def migrate do
    IO.puts "Loading Bird.."
    :ok = Application.load(:bird)

    IO.puts "Starting dependencies.."
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts "Creating repos.."
    Enum.each(@repos, &create_db/1)

    # Start the Repo(s) for myapp
    IO.puts "Starting repos.."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))

    # Run migrations
    Enum.each(@myapps, &run_migrations_for/1)

    # Signal shutdown
    IO.puts "Success!"
    :init.stop()
  end

  defp create_db(repo) do
    case repo.__adapter__.storage_up(repo.config) do
      :ok ->
        IO.puts "The database for #{inspect repo} has been created."
      {:error, :already_up} ->
        IO.puts "The database for #{inspect repo} has already been created."
      {:error, term} when is_binary(term) ->
        IO.puts "The database for #{inspect repo} couldn't be created, reason given: #{term}."
      {:error, term} ->
        IO.puts "The database for #{inspect repo} couldn't be created, reason given: #{inspect term}."
    end
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(Listings.Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end
