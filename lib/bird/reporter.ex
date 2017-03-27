defmodule Bird.Reporter do
  @slack_url "https://slack.com/api/chat.postMessage"
  @token Application.get_env(:bird, :slack_token)

  def post_listings(listings) do
    listings
    |> Enum.reduce("", &(listing_to_text/2))
    |> post
  end

  defp listing_to_text(%{price: price, title: title, link: link}, text) do
    text <> "\n$#{price} | #{title}\n#{link}"
  end

  def post(text) do
    body = {:form, [{"token", @token}, {"text", text}, {"channel", "general"}]}
    type = %{"Content-type" => "application/x-www-form-urlencoded"}
    HTTPoison.post(@slack_url, body, type)
  end
end
