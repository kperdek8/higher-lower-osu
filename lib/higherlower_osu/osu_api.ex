defmodule HigherlowerOsu.OsuAPI do
  @moduledoc """
  Context for making requests to the osu! API.

  For simplicity, this module lacks priority queue which in combination with rate limit on API endpoint
  may lead to potentially long queue time to execute. Additionally requests are being sent during rate limit
  check in intervals of length specified in `@ratelimit_check_interval`

  This shouldn't be a problem for scope of this project where entire database may be fetched from scratch
  in few hours and after that standard usage should not hit rate limit.

  Every process making call to this module should either process it asynchrounously or
  be written in a way where prolonged wait time doesn't pose a problem.
  """

  require Logger
  use GenServer

  @api_url "https://osu.ppy.sh/api/v2"

  @default_rate_limit 200
  @ratelimit_check_interval 30_000 # 30 seconds

  # Public API
  def send_request(endpoint, headers \\ []) do
    caller = self()
    GenServer.cast(__MODULE__, {:send_request, endpoint, headers, caller})
    receive do
      {:api_response, response} -> response
    end
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  # GenServer API
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    rate_limit = case check_ratelimit() do
      {:ok, rate_limit_remaining} -> rate_limit_remaining
      _ -> @default_rate_limit
    end
    state = %{
      queue: [],
      rate_limit: rate_limit
    }

    schedule_ratelimit_check()

    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(_, _from, state) do
    {:ok, :invalid_call, state}
  end

  @impl true
  def handle_cast({:send_request, endpoint, headers, caller}, state) do
    new_queue = state.queue ++ [{caller, endpoint, headers}]
    {:noreply, %{state | queue: new_queue}}
  end

  @impl true
  def handle_cast({:update_state, new_state}, _state) do
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:check_ratelimit, state) do
    Logger.info("Sending periodic rate limit check")
    new_rate_limit = case check_ratelimit() do
      {:ok, rate_limit_remaining} -> rate_limit_remaining
      _ -> state.rate_limit
    end
    Logger.info("Remaining rate limit: #{new_rate_limit}")
    Logger.info("Queue length: #{length(state.queue)}.")
    state = process_queue(%{state | rate_limit: new_rate_limit})
    schedule_ratelimit_check()

    {:noreply, state}
  end

  defp check_ratelimit() do
    case fetch_data("beatmapsets/1") do
      {:ok, _data, rate_limit_remaining} ->
        {:ok, rate_limit_remaining}
      {:error, :rate_limit_reached} -> {:ok, 0}
      {:error, reason} -> {:error, reason} # This should happen only in rare circumstances like API service being down.
    end
  end

  defp fetch_data(endpoint, headers \\ []) do
    with {:ok, token} <- HigherlowerOsu.OsuTokenCache.get_token() do
      url = "#{@api_url}/#{endpoint}"
      headers = [{"Authorization", "Bearer #{token}"} | headers]
      make_request(url, headers)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp make_request(url, headers) do
    opts = [timeout: 60_000, recv_timeout: 60_000]
    case HTTPoison.get(url, headers, opts) do
      {:ok, %HTTPoison.Response{status_code: 200, headers: headers, body: body}} ->
        rate_limit_remaining = headers
          |> Enum.into(%{})
          |> Map.get("X-Ratelimit-Remaining", "0")
        {:ok, Jason.decode!(body), String.to_integer(rate_limit_remaining)}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
      {:ok, %HTTPoison.Response{status_code: 429}} -> {:error, :rate_limit_reached}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp schedule_ratelimit_check() do
    Process.send_after(self(), :check_ratelimit, @ratelimit_check_interval)
  end

  defp process_queue(state) do
    rate_limit = state.rate_limit
    {requests_to_process, remaining_queue} = Enum.split(state.queue, rate_limit)

    Enum.each(requests_to_process, fn {caller, endpoint, headers} ->
      Task.start(fn ->
        case fetch_data(endpoint, headers) do
          {:ok, data, new_rate_limit} ->
            send(caller, {:api_response, {:ok, data, new_rate_limit}})
          error ->
            send(caller, {:api_response, error})
        end
      end)
    end)

    # Update state with the remaining queue
    %{state | queue: remaining_queue, rate_limit: max(rate_limit - length(requests_to_process), 0)}
  end
end
