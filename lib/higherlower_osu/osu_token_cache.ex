defmodule HigherlowerOsu.OsuTokenCache do
  @moduledoc """
  Context for managing OAuth token for osu! API.
  """
  use GenServer
  import HigherlowerOsu.OsuAuth

  @refresh_threshold 33200 # Seconds before expiration to refresh

  # Public API
  def get_token do
    GenServer.call(__MODULE__, :get_token)
  end

  # GenServer API
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    state = %{token: nil, expires_at: nil}
    {:ok, state}
  end

  @doc """
  Returns API authentication token.

  If token expired, generates new one.
  """
  @impl GenServer
  def handle_call(:get_token, _from, %{token: token, expires_at: expires_at} = state) do
    if not token_expired?(expires_at) do
      {:reply, {:ok, token}, state}
    else
      refresh_token(state)
    end
  end

  # Generates new token
  defp refresh_token(state) do
    case get_access_token() do
      {:ok, %{token: new_token, expires_in: expires_in}} ->
        new_state = update_state_with_token(state, new_token, expires_in)
        {:reply, {:ok, new_token}, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  # Updates state with new token
  defp update_state_with_token(state, new_token, expires_in) do
    new_expires_at = System.system_time(:second) + expires_in
    %{state | token: new_token, expires_at: new_expires_at}
  end

  # Checks if token expired
  defp token_expired?(expires_at) when is_nil(expires_at), do: true
  defp token_expired?(expires_at) do
    System.system_time(:second) > (expires_at - @refresh_threshold)
  end
end
