defmodule Bird.Scraper do
  @url "https://sfbay.craigslist.org/search/sfc/hhh?search_distance=1&postal=94103&nh=18&min_price=1500&max_price=3200&availabilityMode=0"

  def scrape do
    case HTTPoison.get(@url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Bird.Parser.parse
        |> Enum.at(1)
        |> IO.inspect

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
