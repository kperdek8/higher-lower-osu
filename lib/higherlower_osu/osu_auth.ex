defmodule HigherlowerOsu.OsuAuth do
  @moduledoc """
  Context for managing osu! API verification.
  """

  @auth_endpoint "https://osu.ppy.sh/oauth/token"

  # BG Link
  # https://assets.ppy.sh/beatmaps/1388631/covers/raw.jpg

  def get_access_token do
    with {:ok, body} <- build_request_body(),
         {:ok, response_body} <- request_access_token(body) do
      {:ok, parse_access_token(response_body)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp build_request_body do
    with {:ok, client_id} <- fetch_env("CLIENT_ID"),
         {:ok, client_secret} <- fetch_env("CLIENT_SECRET") do
      body = %{
        "client_id" => client_id,
        "client_secret" => client_secret,
        "grant_type" => "client_credentials",
        "scope" => "public"
      }

      {:ok, URI.encode_query(body)}
    end
  end

  defp fetch_env(var) do
    case System.get_env(var) do
      nil -> {:error, "#{var} not set in environment"}
      value -> {:ok, value}
    end
  end

  defp request_access_token(body) do
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Accept", "application/json"}
    ]

    case HTTPoison.post(@auth_endpoint, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} -> {:ok, response_body}
      {:ok, %HTTPoison.Response{status_code: status_code, body: error_body}} ->
        {:error, "Request failed with status #{status_code}: #{error_body}"}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  defp parse_access_token(body) do
    %{"access_token" => access_token, "expires_in" => expires_in} =
      Jason.decode!(body)

    %{token: access_token, expires_in: expires_in}
  end
end
