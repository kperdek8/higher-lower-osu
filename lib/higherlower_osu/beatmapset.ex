defmodule HigherlowerOsu.Beatmapsets do
  @moduledoc """
  Context for managing `Beatmapsets` records.
  """

  import Ecto.Query
  alias HigherlowerOsu.Repo
  alias HigherlowerOsu.Beatmapsets.Beatmapset

  def get_random_beatmapset(mode, exclude_ids \\ []) do
    Beatmapset
    |> where([b], ^mode in b.modes)
    |> where([b], b.id not in ^exclude_ids)
    |> order_by(fragment("RANDOM()"))
    |> limit(1)
    |> Repo.one()
  end

  def insert_or_update_beatmapset(%Beatmapset{} = beatmapset) do
    beatmapset
    |> Beatmapset.changeset(Map.from_struct(beatmapset))
    |> Ecto.Changeset.change(updated_at: DateTime.utc_now(:second))  # Force updated_at change to keep track of last API request
    |> Repo.insert_or_update!(
      on_conflict: {:replace, [:title, :artist, :creator, :favourite_count, :play_count, :ranked, :ranked_date, :updated_at]},
      conflict_target: [:id],
      returning: true)
    update_modes(beatmapset) # Join existing modes with potential new mode
  end

  def update_beatmapset(%Beatmapset{} = beatmapset) do
    case Repo.get(Beatmapset, beatmapset.id) do
      nil -> {:error, :not_found}
      %Beatmapset{} = existing_beatmapset ->
          existing_beatmapset
          |> Ecto.Changeset.change(Map.from_struct(beatmapset))
          |> Ecto.Changeset.change(updated_at: DateTime.utc_now(:second))  # Force updated_at change to keep track of last API request
          |> Repo.update()
        update_modes(beatmapset) # Join existing modes with potential new mode
    end
  end

  defp update_modes(%Beatmapset{} = beatmapset) do
    case Repo.get(Beatmapset, beatmapset.id) do
      nil -> {:error, :not_found}
      %Beatmapset{} = existing_beatmapset ->
        merged_modes = Enum.uniq(existing_beatmapset.modes ++ beatmapset.modes)

        existing_beatmapset
        |> Ecto.Changeset.change(modes: merged_modes)
        |> Repo.update()
    end
  end

  def delete_beatmapset(beatmapset_id) do
    case Repo.get(Beatmapset, beatmapset_id) do
      nil ->
        {:error, :not_found}
      beatmapset ->
        Repo.delete(beatmapset)
    end
  end
end
