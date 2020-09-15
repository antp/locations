defmodule Locations do
  @moduledoc """
  Public entry point for the Locations context
  """
  alias Locations.Schema.Location

  alias Locations.Location.{
    GetLocations,
    AddLocation,
    UpdateLocation,
    RemoveLocation,
    GetMapFor,
    UpdateGeoLocation
  }

  defdelegate get_locations(), to: GetLocations, as: :call
  defdelegate add_location(attrs), to: AddLocation, as: :call
  defdelegate update_location(location, attrs), to: UpdateLocation, as: :call
  defdelegate remove_location(attrs), to: RemoveLocation, as: :call
  defdelegate update_geo_location(location, attrs), to: UpdateGeoLocation, as: :call

  defdelegate get_map_for(location), to: GetMapFor, as: :call

  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end
end
