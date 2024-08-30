defmodule HigherlowerOsu.Repo.Migrations.CreateBeatmapsetsTable do
  use Ecto.Migration

  def change do
    create table(:beatmapsets, primary_key: false) do
      add :id, :integer, primary_key: true
      add :title, :string
      add :artist, :string
      add :creator, :string
      add :favourite_count, :integer
      add :play_count, :integer
      add :ranked, :integer
      add :ranked_date, :utc_datetime # Might be null
      add :modes, {:array, :string} # Array of strings for different modes

      timestamps(type: :utc_datetime)
    end
    create unique_index(:beatmapsets, [:id])
  end
end
