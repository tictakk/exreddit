defmodule ExReddit.OAuth do
  def get_token() do
    request_token().body
      |> Poison.decode
      |> ok # TODO: Handle errors
      |> Map.get("access_token")
  end

  defp request_token do
    config = get_config()
    headers = get_auth_headers(config)
    HTTPotion.post!("https://www.reddit.com/api/v1/access_token", headers)
  end

  defp get_config() do
    %{
      username: Application.get_env(:exreddit, :username),
      password: Application.get_env(:exreddit, :password),
      client_id: Application.get_env(:exreddit, :client_id),
      secret: Application.get_env(:exreddit, :secret)
    }
  end

  defp get_auth_headers(config) do
    [
      body: "grant_type=password&username=#{config[:username]}&password=#{config[:password]}",
      headers: [
        "User-Agent": "exreddit-api-wrapper",
        "Content-Type": "application/x-www-form-urlencoded"
      ],
      basic_auth: {config[:client_id], config[:secret]}
    ]
  end

  defp ok({:ok, result}), do: result
end
