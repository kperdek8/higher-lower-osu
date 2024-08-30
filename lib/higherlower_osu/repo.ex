defmodule HigherlowerOsu.Repo do
  use Ecto.Repo,
    otp_app: :higherlower_osu,
    adapter: Ecto.Adapters.Postgres,
    url: System.get_env("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  def init(_, config) do
    config = config
      |> Keyword.put(:username, System.get_env("PGUSER") || "postgres")
      |> Keyword.put(:password, System.get_env("PGPASSWORD") || "postgres")
      |> Keyword.put(:database, System.get_env("PGDATABASE") || "higherlower_osu_dev")
      |> Keyword.put(:hostname, System.get_env("PGHOST") || "localhost")
      |> Keyword.put(:port, (System.get_env("PGPORT") || "5432") |> String.to_integer)
    {:ok, config}
  end
end
