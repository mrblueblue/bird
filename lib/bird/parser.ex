defmodule Bird.Parser do
  use Timex

  @url "https://sfbay.craigslist.org"

  defp toListing(row) do
    id =
      row
      |> Floki.attribute(".result-row", "data-pid")
      |> to_string
      |> String.to_integer

    created_at =
      row
      |> Floki.attribute(".result-date", "datetime")
      |> to_string
      |> String.split(" ")
      |> Enum.at(0)
      |> Timex.parse("{YYYY}-{0M}-{0D}")

    title =
      row
      |> Floki.find(".result-title")
      |> Floki.text

    price =
      row
      |> Floki.find(".result-meta .result-price")
      |> Floki.text

    link =
      row
      |> Floki.attribute(".result-title", "href")
      |> to_string
      |> (&(@url <> &1)).()

    neighborhood =
      row
      |> Floki.find(".result-hood")
      |> Floki.text
      |> String.replace("(", "")
      |> String.replace(")", "")

    %{
      id: id,
      created_at: created_at,
      title: title,
      price: price,
      link: link,
      neighborhood: neighborhood
    }
  end

  def parse(html) do
    Floki.find(html, ".result-row")
      |> (fn(n) -> Enum.map(n, &(toListing &1)) end).()
      |> IO.inspect

  end
end
