defmodule HigherlowerOsuWeb.Helpers do
  @moduledoc """
  Helper module to format numbers
  """

  @doc """
  Formats number.
  """
  def format_number(number) do
    number
    |> format_number_with_commas()
  end

  @doc """
  Rounds up number to n-th place from the end.
  """
  def round_up(number, n) when is_integer(number) and is_integer(n) and n > 1 do
    rounding_factor = :math.pow(10, n - 1) |> round()
    ((number + rounding_factor - 1) |> div(rounding_factor)) * rounding_factor
  end

  @doc """
  Puts commas between each order of magnitude.
  """
  def format_number_with_commas(number) when is_integer(number) do
    number
    |> Integer.to_string()
    |> String.reverse()
    |> String.replace(~r/.{3}(?=.)/, "\\0,")
    |> String.reverse()
  end

  def format_number_with_commas(_), do: "missing value"
end
