defmodule HigherlowerOsu.Beatmaps.Beatmap do
  @doc """
  Defines struct with most important `Beatmap` fields.

  Currently implemented as helper struct for processing requests and is not used in database.
  """

  alias HigherlowerOsu.Beatmaps.Beatmap
  defstruct [:id, :beatmapset_id, :mode, :status, :beatmapset]

  def convert_to_beatmap(dict) when is_map(dict) do
    %Beatmap{
      id: Map.get(dict, "id"),
      beatmapset_id: Map.get(dict, "beatmapset_id"),
      mode: Map.get(dict, "mode"),
      status: Map.get(dict, "status"),
      beatmapset: convert_beatmapset(Map.get(dict, "beatmapset"))
    }
  end

  defp convert_beatmapset(nil), do: nil
  defp convert_beatmapset(beatmapset_dict) when is_map(beatmapset_dict) do
    HigherlowerOsu.Beatmapsets.Beatmapset.convert_to_beatmapset(beatmapset_dict)
  end
end
