defmodule HigherlowerOsuWeb.CriteriaDropdownComponent do
  @moduledoc """
  A Phoenix LiveView component for rendering a dropdown menu that allows users to select a criteria for comparison in the HigherLower Osu! game.
  """
  use HigherlowerOsuWeb, :live_component

  def render(assigns) do
    ~H"""
    <select id={@id} name={@name} phx-change="select_criteria">
      <%= for {key, label} <- @criteria_map do %>
        <option value={key} selected={key == @selected_criteria}><%= label %></option>
      <% end %>
    </select>
    """
  end
end
