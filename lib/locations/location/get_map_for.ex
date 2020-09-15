defmodule Locations.Location.GetMapFor do
  @moduledoc """
  Perform logic related getting a map from the OpenStreetMap Nominatim service
  """

  alias Locations.GeoEncode.{
    Address,
    Lookup,
    Nominatim
  }

  @doc """
  Get a map from Nominatim
  """
  def call(location) do
    address = Address.build_address(location)

    case Lookup.geoencode(address) do
      {:ok, 200, response} ->
        Nominatim.get_location(response)

      other ->
        other
    end
  end
end
