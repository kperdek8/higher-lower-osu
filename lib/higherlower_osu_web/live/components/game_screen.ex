  defmodule HigherlowerOsuWeb.GameScreenComponent do
    @moduledoc """
    LiveView component handling game screen.
    """

    use HigherlowerOsuWeb, :live_component
    import HigherlowerOsuWeb.Helpers

    def render(assigns) do
      ~H"""
      <div id="game" class="relative flex flex-grow max-w-1xl clear-text">
        <div id="preloaded-image" class="hidden" phx-hook="PreloadImage" data-url={@preloaded_bg_url}></div>
        <div class="absolute bottom-0 left-1/2 transform -translate-x-1/2 text-center p-2 py-4 text-white rounded">
          <h2 class="text-xl font-bold">Score: <%= @score %></h2>
        </div>

        <!-- First beatmap -->
        <div id="first-map-background" class="flex-1 bg-gray-300 text-center content-center" style={"background-image: url('#{@bg1_url}'); background-size: cover; background-position: center;"}>
          <div id="first-map-data-container" class="flex flex-col h-1/5">
            <div id="first-map-info">
              <p class="text-3xl">
                <%= if @first_map do %>
                  <a href={"https://osu.ppy.sh/beatmapsets/#{@first_map.id}"} target="_blank" class="hover:underline">
                    <%= "#{@first_map.artist} - #{@first_map.title}, mapped by #{@first_map.creator}" %>
                  </a>
                <% else %>
                  MAP METADATA HERE
                <% end %>
              </p>
              <p>has</p>
            </div>
            <div id="first-map-values" >
              <p class="text-5xl font-bold text-yellow-200" >
                <%= if @first_map do %>
                  <%= format_number(Map.get(@first_map, @criteria)) %>
                <% else %>
                  VALUE HERE
                <% end %>
              </p>
              <p><%= @criteria_map[@criteria] %></p>
            </div>
          </div>
        </div>

        <!-- Second beatmap -->
        <div id="second-map-background" class="flex-1 bg-gray-300 text-center content-center" style={"background-image: url('#{@bg2_url}'); background-size: cover; background-position: center;"}>
          <div id="second-map-data-container" class="flex flex-col h-1/5">
            <div id="second-map-info">
              <p class="text-3xl">
                <%= if @second_map do %>
                  <a href={"https://osu.ppy.sh/beatmapsets/#{@second_map.id}"} target="_blank" class="hover:underline">
                    <%= "#{@second_map.artist} - #{@second_map.title}, mapped by #{@second_map.creator}" %>
                  </a>
                <% else %>
                  MAP METADATA HERE
                <% end %>
              </p>
              <p>has</p>
            </div>
            <div id="second-map-actions" class="flex flex-col items-center">
              <%= if @reveal? do %>
                <!-- Show revealed value after guess -->
                <p class="text-5xl font-bold fade-in text-yellow-200" id="revealed-value">
                  <%= format_number(Map.get(@second_map, @criteria)) %>
                </p>
              <% else %>
                <!-- Show buttons if no guess is made yet -->
                <button phx-click="guess" phx-value-guess="higher" class="bg-transparent hover:bg-white text-white font-bold py-2 px-4 border-4 border-white-500 rounded-full hover:border-transparent w-48 mb-2 clear-box">
                  <p>Higher</p>
                </button>
                <button phx-click="guess" phx-value-guess="lower" class="bg-transparent hover:bg-white text-white font-bold py-2 px-4 border-4 border-white-500 rounded-full hover:border-transparent w-48 mb-2 clear-box">
                  <p>Lower</p>
                </button>
              <% end %>
              <p><%= "#{@criteria_map[@criteria]}" %> than <%= @first_map && @first_map.title || "MAP NAME HERE" %></p>
            </div>
          </div>
        </div>
      </div>
      """
    end
  end
