defmodule HigherlowerOsu.BeatmapsetActions do
  @moduledoc """
  Context for performing actions on `Beatmapset` objects.
  This module combines database operations with business logic.
  """

  import HigherlowerOsu.Beatmapsets
  import HigherlowerOsu.BeatmapsetFetcher
  alias HigherlowerOsu.Beatmapsets.Beatmapset
  require Logger

  @asset_url "https://assets.ppy.sh/beatmaps"
  @background_url_suffix "covers/raw.jpg"

  def get_background_url(beatmapset_id) do
    "#{@asset_url}/#{beatmapset_id}/#{@background_url_suffix}"
  end

  def get_random(mode, exclude_ids \\ []) do
    case get_random_beatmapset(mode, exclude_ids) do
      nil ->
        {:error, :no_maps_left}
      beatmapset ->
        %Beatmapset{id: id} = beatmapset
        case should_update?(beatmapset) do
          :no ->
            {:ok, beatmapset}
          :in_background ->
            Task.start(fn -> update(id) end)
            {:ok, beatmapset}
        end
    end
  end

  @no_update_threshold_days 1

  defp should_update?(%Beatmapset{updated_at: updated_at}) do
    diff = DateTime.diff(DateTime.utc_now(), updated_at, :day)
    case diff do
      d when d <= @no_update_threshold_days -> :no
      _ -> :in_background
    end
  end

  defp update(beatmapset_id) do
    fetch_and_update_beatmapset(beatmapset_id)
  end
end
