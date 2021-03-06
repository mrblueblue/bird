defmodule Listings.Listing do
  use Ecto.Schema

  schema "listings" do
    field :pid, :string
    field :date, :date
    field :title, :string
    field :price, :integer
    field :link, :string
    field :hood, :string
  end
end
