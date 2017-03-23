defmodule Listings.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :pid, :string
      add :date, :date
      add :title, :string
      add :price, :integer
      add :link, :string
      add :hood, :string
    end
  end
end
