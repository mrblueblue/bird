defmodule Bird.Scraper do
  use GenServer
  @url "https://sfbay.craigslist.org/search/sfc/hhh?search_distance=1&postal=94103&nh=18&min_price=0&max_price=4000&availabilityMode=0"

  def start_link do
    GenServer.start_link __MODULE__, nil
  end

  def init(queue) do
    do_scrape()
    {:ok}
  end

  defp do_scrape do
    scrape()
    :timer.sleep(1200000)
    do_scrape()
  end

  def scrape do
    case HTTPoison.get(@url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        listings =
          body
          |> Bird.Parser.parse
          |> Bird.Parser.reject_saved

        listings |> Bird.Reporter.post_listings
        listings |> Enum.each(&(Listings.Repo.insert &1))

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
  
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

end
