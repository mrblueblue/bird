defmodule Bird.Scraper do
  use GenServer
  @url Bird.Helpers.form_scrape_url()

  def start_link do
    GenServer.start_link __MODULE__, nil
  end

  def init(_state) do
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
          |> Bird.Helpers.reject_saved_listings

        listings
          |> Bird.Helpers.listings_to_text
          |> Bird.Reporter.post_to_slack

        listings |> Enum.each(&(Listings.Repo.insert &1))

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

end
