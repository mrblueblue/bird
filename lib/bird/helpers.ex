defmodule Bird.Helpers do
  require Ecto.Query

  @url Application.get_env :bird, :craigslist_url
  @neighborhoods Application.get_env :bird, :neighborhoods
  @min_price Application.get_env :bird, :min_price
  @max_price Application.get_env :bird, :max_price

  def form_scrape_url do
    neighborhoods = Enum.reduce(@neighborhoods, "", &(&2 <> "nh=#{&1}&"))
    pricing = "min_price=#{@min_price}&max_price=#{@max_price}"
    opts = "bundleDuplicates=1&availabilityMode=0"
    "#{@url}/search/sfc/hhh?#{neighborhoods}#{pricing}&#{opts}"
  end

  def listings_to_text(listings) do
    Enum.reduce listings, "", fn(listing, text) ->
      text <> "\n$#{listing.price} | #{listing.title}\n#{listing.link}"
    end
  end

  def reject_saved_listings(listings) do
    saved_listings = find_saved_listings(listings)
    listings |> Enum.reject(&(Enum.member?(saved_listings, &1.pid)))
  end

  defp find_saved_listings(listings) do
    listings
      |> Enum.map(&(&1.pid))
      |> compose_listings_query
      |> Listings.Repo.all
      |> Enum.map(&(&1.pid))
  end

  defp compose_listings_query(listings) do
    Enum.reduce listings, nil, fn(listing, query) ->
      if query == nil do
        Listings.Listing |> Ecto.Query.where(pid: ^listing)
      else
        query |> Ecto.Query.or_where(pid: ^listing)
      end
    end
  end

end
