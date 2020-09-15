defmodule Locations.Location.UpdateGeoLocation do
  @moduledoc """
  Perform the logic to update a location with GEO data
  """
  import Ecto.Changeset
  alias Locations.Repo

  alias Locations.Schema.Location

  @doc """
  Update the GEO data for a location to the database
  """
  def call(location, %{geo_error: geo_error} = attrs) when nil != geo_error do
    location
    |> Location.geo_cs(attrs)
    |> put_change(:geolocation, nil)
    |> Repo.update()
  end

  def call(location, attrs) do
    geolocation = %Geo.Point{coordinates: {attrs.lat, attrs.lon}, srid: 4326}

    location
    |> Location.geo_cs(attrs)
    |> put_change(:geolocation, geolocation)
    |> Repo.update()
  end
end
