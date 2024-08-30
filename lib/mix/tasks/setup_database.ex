defmodule Mix.Tasks.SetupDatabase do
  use Mix.Task

  @shortdoc "Sets up the database, runs migrations, and seeds data"
  def run(_) do
    # Create and migrate database
    Mix.Task.run("ecto.create")
    Mix.Task.run("ecto.migrate")

    # Run seeds
    Mix.Task.run("run", ["priv/repo/seeds.exs"])

    IO.puts("Database setup completed!")
  end
end
