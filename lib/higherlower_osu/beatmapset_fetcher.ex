defmodule HigherlowerOsu.BeatmapsetFetcher do
  @moduledoc """
  Provides functionality for batch fetching `Beatmapset` data from an API endpoint and updating the database.

  **Overview:**

  - **Batch Fetching**: This module fetches `Beatmapset` data indirectly by querying the `Beatmap` endpoint. This approach is advantageous because:
    1. Each `Beatmap` contains information about the `Beatmapset` it belongs to, allowing the retrieval of `Beatmapset` data through `Beatmap` queries.
    2. The `Beatmap` endpoint supports fetching data in batches of up to 50 IDs, while the `Beatmapset` endpoint does not, making it more efficient for bulk operations.

  - **Efficiency Considerations**:
    - On average, a `Beatmapset` consists of approximately 2.5 `Beatmaps`. Hence, querying `Beatmap` data is about 20 times faster.
    - Processing overhead for responses is minimal compared to the potential delays caused by rate limiting.
  """
  import HigherlowerOsu.OsuAPI
  import HigherlowerOsu.Beatmaps.Beatmap
  import HigherlowerOsu.Beatmapsets
  import HigherlowerOsu.Beatmapsets.Beatmapset

  alias HigherlowerOsu.Beatmaps.Beatmap

  require Logger

  @beatmap_endpoint "beatmaps"
  @beatmapset_endpoint "beatmapsets"
  @max_batch_size 50

  @doc """
  Fetches one or many beatmapsets and inserts them into database.

  It should be used only for updating existing entries. Looking up beatmaps (if possible)
  is faster because they can be batched into group of 50 per one request.
  """
  def fetch_and_update_beatmapset(beatmapset_id) when is_integer(beatmapset_id) do
    beatmapset_id
    |> fetch_beatmapset()
    |> process_beatmapset()
  end

  def fetch_and_update_beatmapsets(beatmapset_ids) when is_list(beatmapset_ids) do
    beatmapset_ids
    |> Enum.each(fn beatmapset_id ->
      Task.start(fn ->
        fetch_beatmapset(beatmapset_id)
        |> process_beatmapset()
      end)
    end)
  end

  @doc """
  Fetches beatmap data and uses it to extract and insert beatmapset data into database.

  Fetching beatmapset data using beatmap IDs is more efficient because it's possible to
  lookup 50 beatmaps at once, even if multiple beatmaps may be a part of the same beatmapset.
  """
  def fetch_and_update_from_beatmap(beatmap_id) when is_integer(beatmap_id) do
    with {:ok, beatmap, _ratelimit} <- fetch_beatmap(beatmap_id) do
      beatmap
      |> convert_to_beatmap()
      |> process_beatmap()
    end
  end

  def fetch_and_update_from_beatmaps(beatmap_ids) when is_list(beatmap_ids) do
    beatmap_ids
    |> Enum.chunk_every(@max_batch_size)
    |> Enum.each(fn batch_ids ->
      Task.start(fn ->
        send_batch(batch_ids, @beatmap_endpoint)
        |>  process_beatmaps()
      end)
    end)
  end

  @doc """
  Fetches beatmap data from API endpoint.

  During mass fetching consider using fetch_beatmaps/1 which allows for more effective rate limit
  usage by sending batch of 50 IDs per request.
  """
  def fetch_beatmap(beatmap_id) when is_integer(beatmap_id) do
    send_request("#{@beatmap_endpoint}/#{beatmap_id}")
  end

  @doc """
  Fetches multiple beatmaps data from API endpoint.

  Passing IDs in a list allows for sending batch of 50 IDs per request.
  If all IDs belong to deleted beatmaps, response will contain empty list.
  """
  def fetch_beatmaps(beatmap_ids) when is_list(beatmap_ids) do
    beatmap_ids
    |> Enum.chunk_every(@max_batch_size)
    |> Enum.map(fn batch_ids ->
      Task.async(fn ->
        send_batch(batch_ids, @beatmap_endpoint)
      end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))
  end

  @doc """
  Fetches beatmapset data from API endpoint.
  """
  def fetch_beatmapset(beatmapset_id) when is_integer(beatmapset_id) do
    send_request("#{@beatmapset_endpoint}/#{beatmapset_id}")
  end

  @doc """
  Fetches multiple beatmapsets data from API endpoint.
  """
  def fetch_beatmapsets(beatmap_ids) when is_list(beatmap_ids) do
    beatmap_ids
    |> Enum.map(fn id ->
      Task.async(fn ->
        fetch_beatmapset(id)
      end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))
  end

  # Prepares url with array of ids as parameter then sends request
  defp send_batch(ids, endpoint) do
    query_params = Enum.map(ids, &("ids[]=#{&1}")) |> Enum.join("&")
    send_request("#{endpoint}?#{query_params}")
  end

  defp process_beatmaps({:ok, %{"beatmaps" => beatmap_list}, _rate_limit_remaining}) do
    Enum.each(beatmap_list, fn beatmap ->
      beatmap
      |> convert_to_beatmap()
      |> process_beatmap()
    end)
  end
  defp process_beatmaps({:error, reason}), do: Logger.warning("Failed to fetch beatmaps: #{reason}")

  # Read mode and beatmapset from beatmap data
  defp process_beatmap(%Beatmap{} = beatmap) do
    if ranked?(beatmap.beatmapset) do
      beatmap.beatmapset
      |> insert_mode(beatmap.mode)
      |> insert_or_update_beatmapset()
    end
  end

  defp process_beatmapset({:ok, beatmapset, _rate_limit_remaining}) do
    beatmapset
    |> convert_to_beatmapset()
    |> insert_or_update_beatmapset()
  end
  defp process_beatmapset({:error, :not_found}), do: :ok # Ignore not found

  @ranked 1
  defp ranked?(%{ranked: ranked}) do
    ranked == @ranked
  end
end
