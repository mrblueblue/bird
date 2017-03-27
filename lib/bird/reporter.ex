defmodule Bird.Reporter do
  @slack_url "https://slack.com/api/chat.postMessage"
  @type %{"Content-type" => "application/x-www-form-urlencoded"}
  @form [
    {"token", Application.get_env(:bird, :slack_token)},
    {"username", Application.get_env(:bird, :bot_name)},
    {"icon_url", Application.get_env(:bird, :icon_url)},
    {"channel", Application.get_env(:bird, :slack_channel)}
  ]

  def post_to_slack(text) do
    body = {:form, Enum.concat(@form, [{"text", text}])}
    HTTPoison.post(@slack_url, body, @type)
  end
end
