defmodule Bird.Parser do
  use Timex

  @url "https://sfbay.craigslist.org"

  defp to_listing(row) do
    pid =
      row
      |> Floki.attribute(".result-row", "data-pid")
      |> to_string

    date =
      row
      |> Floki.attribute(".result-date", "datetime")
      |> to_string
      |> String.split(" ")
      |> Enum.at(0)
      |> Timex.parse!("{YYYY}-{0M}-{0D}")
      |> Ecto.Date.cast!

    title =
      row
      |> Floki.find(".result-title")
      |> Floki.text

    price =
      row
      |> Floki.find(".result-meta .result-price")
      |> Floki.text
      |> String.split("$")
      |> Enum.at(1)
      |> String.to_integer

    link =
      row
      |> Floki.attribute(".result-title", "href")
      |> to_string
      |> (&(@url <> &1)).()

    hood =
      row
      |> Floki.find(".result-hood")
      |> Floki.text
      |> String.replace("(", "")
      |> String.replace(")", "")

    %Listings.Listing{
      pid: pid,
      date: date,
      title: title,
      price: price,
      link: link,
      hood: hood
    }
  end

  def parse(html) do
    Floki.find(html, ".result-row")
      |> (fn(n) -> Enum.map(n, &(to_listing &1)) end).()
  end

  def reject_saved(listings) do
    saved_listings =
      listings
      |> Enum.map(&(&1.pid))
      |> Enum.reduce(nil, &listings_query/2)
      |> Listings.Repo.all
      |> Enum.map(&(&1.pid))

    listings
      |> Enum.reject(&(Enum.member?(saved_listings, &1.pid)))
  end

  defp listings_query(listing, query) do
    require Ecto.Query
    if query == nil do
      Listings.Listing |> Ecto.Query.where(pid: ^listing)
    else
      query |> Ecto.Query.or_where(pid: ^listing)
    end
  end
end
