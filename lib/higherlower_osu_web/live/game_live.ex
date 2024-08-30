defmodule HigherlowerOsuWeb.GamePageLive do
  @moduledoc """
  Main LiveView handling the game state for the Higher Lower Osu! game.

  This LiveView is responsible for managing the entire game lifecycle, including starting the game, handling user guesses, and updating the game state.
  """
  require Logger
  use HigherlowerOsuWeb, :live_view

  import HigherlowerOsu.BeatmapsetActions
  import HigherlowerOsuWeb.Helpers

  @next_map_timeout 1000 # Miliseconds
  @playcount_round_factor 4
  @favourite_count_round_factor 2

  def mount(_params, _session, socket) do
    default_criteria = :play_count
    default_mode = "osu"

    criteria_map = %{
      play_count: "playcount",
      favourite_count: "favourites"
    }
    mode_map = %{
      "osu" => "osu!standard",
      "mania" => "osu!mania",
      "taiko" => "osu!taiko",
      "fruits" => "osu!catch"
    }

    {:ok,
      assign(socket,
        criteria_map: criteria_map,
        criteria: default_criteria,
        mode_map: mode_map,
        mode: default_mode,
        game_state: :start
    )}
  end

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>HigherLower Osu!</title>
      <link rel="preconnect" href="https://assets.ppy.sh/">
      <link rel="dns-prefetch" href="https://assets.ppy.sh/">
    </head>
    <body class="flex flex-col">
      <div class="min-h-screen flex flex-col justify-between">
        <!-- Main Content -->
        <main class="flex flex-grow flex-col bg-gray-100">
          <%= case @game_state do %>
          <% :start -> %>
            <.live_component module={HigherlowerOsuWeb.StartScreenComponent} id="start-screen" criteria={@criteria} criteria_map={@criteria_map} mode={@mode} mode_map={@mode_map}/>
          <% :playing -> %>
            <.live_component module={HigherlowerOsuWeb.GameScreenComponent} id="game-screen" first_map={@first_map} second_map={@second_map} bg1_url={@bg1_url} bg2_url={@bg2_url} criteria={@criteria} criteria_map={@criteria_map} score={@score} reveal?={@reveal?} preloaded_bg_url={@preloaded_bg_url}/>
          <% :lost -> %>
            <.live_component module={HigherlowerOsuWeb.LosingScreenComponent} id="losing-screen" score={@score} criteria={@criteria} criteria_map={@criteria_map} mode={@mode} mode_map={@mode_map}/>
      <% end %>
        </main>

        <!-- Footer -->
        <div id="hover-area"></div>
        <footer id="hidden-footer" class="fixed bottom-0 left-0 right-0 bg-blue-600 text-sm italic p-2 text-center text-white">
          <div class="flex justify-center items-center flex-col md:flex-row space-y-2 md:space-y-0 md:space-x-4 max-w-7xl mx-auto">
            <div class="text-sm">
              <a href="https://higherlowergame.com/" target="_blank" class="hover:underline">Inspired by Higher Lower Game </a>
            </div>
            <div class="text-sm">
              <a href="https://github.com/kperdek8" target="_blank" class="hover:underline">Developed by kperdek8</a>
            </div>
          </div>
        </footer>
      </div>
    </body>
    </html>
    """
  end

  def handle_event("select_criteria", %{"criteria" => criteria}, socket) do
    {:noreply, assign(socket, criteria: String.to_atom(criteria))}
  end

  def handle_event("select_mode", %{"mode" => mode}, socket) do
    {:noreply, assign(socket, mode: mode)}
  end

  def handle_event("start_game", _params, socket) do
    {:noreply, start_game(socket)}
  end

  def handle_event("guess", %{"guess" => guess}, socket) do
    criteria = socket.assigns.criteria
    first_map = socket.assigns.first_map
    second_map = socket.assigns.second_map

    correct_guess? = guess_correct?(guess, first_map, second_map, criteria)

    if correct_guess? do
      socket = assign(socket, reveal?: true)
      Process.send_after(self(), :next_map, @next_map_timeout)
      {:noreply, socket}
    else
      socket = assign(socket, reveal?: true)
      Process.send_after(self(), :restart_game, @next_map_timeout)
      {:noreply, socket}
    end
  end

  def handle_info(:next_map, socket) do
    {:noreply, next_map(socket)}
  end

  def handle_info(:restart_game, socket) do
    {:noreply, restart_game(socket)}
  end

  # Fetches new random beatmap and it's background link.
  defp fetch_map_and_bg(mode, exclude_ids \\ []) do
    case get_random(mode, exclude_ids) do
      {:ok, map} ->
        updated_map = round_up_fields(map)
        bg = get_background_url(map.id)
        {:ok, {updated_map, bg}}

      {:error, :no_maps_left} ->
        {:error, :no_maps_left}
    end
  end

  # Rounds up guessed fields to leave player more room for error.
  defp round_up_fields(map) do
    %{map
      | play_count: round_up(map.play_count, @playcount_round_factor),
        favourite_count: round_up(map.favourite_count, @favourite_count_round_factor)
    }
  end

  # Determines whenever player's guess is correct or not.
  defp guess_correct?(guess, first_map, second_map, criteria) do
    case guess do
      "higher" -> Map.get(first_map, criteria) <= Map.get(second_map, criteria)
      "lower" -> Map.get(first_map, criteria) >= Map.get(second_map, criteria)
      _ -> false
    end
  end

  # Restarts game.
  defp restart_game(socket) do
    assign(socket, game_state: :lost)
  end

  # Starts game by setting up default values.
  defp start_game(socket) do
    with mode <- socket.assigns.mode,
        {:ok, {first_beatmapset, bg1_url}} <- fetch_map_and_bg(mode),
        {:ok, {second_beatmapset, bg2_url}} <- fetch_map_and_bg(mode, [first_beatmapset.id]),
        {:ok, {preloaded_beatmapset, preloaded_bg_url}} <- fetch_map_and_bg(mode, [first_beatmapset.id, second_beatmapset.id]) do
      assign(socket,
        game_state: :playing,
        score: 0,
        first_map: first_beatmapset,
        second_map: second_beatmapset,
        preloaded_map: preloaded_beatmapset,
        bg1_url: bg1_url,
        bg2_url: bg2_url,
        preloaded_bg_url: preloaded_bg_url,
        reveal?: false,
        fetched_map_ids: [first_beatmapset.id, second_beatmapset.id, preloaded_beatmapset.id]
      )
    else
      {:error, :no_maps_left} ->
        Logger.error("Initialize database and fetch some beatmaps first")
        assign(socket, game_state: :lost) # Should not happend with initialized database
    end
  end

  # Fetches next map and moves previous map to the left
  defp next_map(socket) do
    case fetch_map_and_bg(socket.assigns.mode, socket.assigns.fetched_map_ids) do
      {:error, :no_maps_left} ->
        assign(socket, fetched_map_ids: [socket.assigns.second_map.id, socket.assigns.preloaded_map.id]) # Reset fetched_map_ids
        |> next_map()

      {:ok, {new_preloaded_map, new_preloaded_bg_url}} ->
        assign(socket,
          first_map: socket.assigns.second_map,
          second_map: socket.assigns.preloaded_map,
          preloaded_map: new_preloaded_map,
          score: socket.assigns.score + 1,
          bg1_url: socket.assigns.bg2_url,
          bg2_url: socket.assigns.preloaded_bg_url,
          preloaded_bg_url: new_preloaded_bg_url,
          reveal?: false,
          fetched_map_ids: socket.assigns.fetched_map_ids ++ [new_preloaded_map.id]
        )
    end
  end
end
