defmodule HigherlowerOsuWeb.LosingScreenComponent do
  @moduledoc """
  LiveView component handling starting screen.
  """

  use HigherlowerOsuWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="losing-screen">
      <h1>You scored: <%= @score %></h1>
      <form phx-submit="start_game">
        <label for="criteria">Choose a criteria:</label>
        <.live_component
          module={HigherlowerOsuWeb.CriteriaDropdownComponent}
          id="criteria-dropdown"
          name="criteria"
          criteria_map={@criteria_map}
          selected_criteria={@criteria}
        />
        <br>
        <label for="criteria">Choose a game mode:</label>
        <.live_component
          module={HigherlowerOsuWeb.GamemodeDropdownComponent}
          id="mode-dropdown"
          name="mode"
          mode_map={@mode_map}
          selected_mode={@mode}
        />
        <br>
        <button type="submit">Start Game</button>
      </form>
    </div>
    """
  end
end
