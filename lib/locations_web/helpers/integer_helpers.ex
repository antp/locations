defmodule LocationsWeb.Helpers.IntegerHelpers do
  def to_i(nil), do: nil
  def to_i(int) when is_integer(int), do: int

  def to_i(bin) when is_binary(bin) do
    case Integer.parse(bin) do
      {int, ""} -> int
      _ -> nil
    end
  end
end
