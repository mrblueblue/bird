defmodule Bird.Parser do
  use Timex

  @url "https://sfbay.craigslist.org"

  defp toListing(row) do
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
      |> (fn(n) -> Enum.map(n, &(toListing &1)) end).()

  end
end
