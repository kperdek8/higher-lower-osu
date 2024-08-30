defmodule HigherlowerOsu.Beatmapsets.Beatmapset do
  @moduledoc """
  Defines the schema and changeset functions for the `Beatmapset` object.

  The `Beatmapset` schema represents a beatmap set in the osu! game, including fields like `title`, `artist`, `creator`, `favourite_count`, `playcount`, `ranked_status`, and `ranked_date`.
  """
  alias HigherlowerOsu.Beatmapsets.Beatmapset
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}  # Use beatmapset IDs used by osu!
  schema "beatmapsets" do
    field :title, :string
    field :artist, :string
    field :creator, :string
    field :favourite_count, :integer
    field :modes, {:array, :string}
    field :play_count, :integer
    field :ranked, :integer
    field :ranked_date, :utc_datetime # Might be null
    timestamps(type: :utc_datetime)
  end

  def convert_to_beatmapset(dict) when is_map(dict) do
    %Beatmapset{
      id: Map.get(dict, "id"),
      artist: Map.get(dict, "artist"),
      creator: Map.get(dict, "creator"),
      favourite_count: Map.get(dict, "favourite_count"),
      modes: [], # Custom added field
      play_count: Map.get(dict, "play_count"),
      ranked: Map.get(dict, "ranked"),
      ranked_date: Map.get(dict, "ranked_date"),
      title: Map.get(dict, "title")
    }
  end

  def insert_mode(%Beatmapset{modes: current_modes} = beatmapset, mode) when is_bitstring(mode) do
    updated_modes =
      if mode in current_modes do
        current_modes
      else
        [mode | current_modes]
      end

    %{beatmapset | modes: updated_modes}
  end

  @doc false
  def changeset(beatmapset, attrs) do
    attrs = maybe_convert_ranked_date(attrs)

    beatmapset
    |> cast(attrs, [:id, :title, :artist, :creator, :favourite_count, :modes, :play_count, :ranked, :ranked_date])
    |> validate_required([:id, :title, :artist, :creator, :favourite_count, :modes, :play_count, :ranked])
    |> unique_constraint(:id)
  end

  defp maybe_convert_ranked_date(attrs) do
    case Map.get(attrs, "ranked_date") do
      nil -> attrs
      ranked_date when is_binary(ranked_date) ->
        case DateTime.from_iso8601(ranked_date) do
          {:ok, datetime, _offset} -> Map.put(attrs, "ranked_date", datetime)
          {:error, _reason} -> attrs
        end
      _ -> attrs
    end
  end
end
