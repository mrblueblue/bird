defmodule Bird.Parser do
  use Timex

  defp to_listing(row) do
    pid =
      row
      |> Floki.attribute(".result-row", "data-pid")
      |> List.first

    date =
      row
      |> Floki.attribute(".result-date", "datetime")
      |> List.first
      |> String.split(" ")
      |> Enum.at(0)
      |> Timex.parse!("{YYYY}-{0M}-{0D}")
      |> Ecto.Date.cast!

    title =
      row
      |> Floki.find(".result-title")
      |> List.first
      |> Floki.text

    price =
      row
      |> Floki.find(".result-meta .result-price")
      |> List.first
      |> Floki.text
      |> String.split("$")
      |> Enum.at(1)
      |> String.to_integer

    link =
      row
      |> Floki.attribute(".result-title", "href")
      |> List.first
      |> Floki.text
      |> (&(Application.get_env(:bird, :craigslist_url) <> &1)).()

    hood =
      row
      |> Floki.find(".result-hood")
      |> List.first
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
    html
    |> Floki.find(".result-row")
    |> (fn(n) -> Enum.map(n, &(to_listing &1)) end).()
  end

end
