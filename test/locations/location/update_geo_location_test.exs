defmodule Locations.Locations.UpdateGeoLocationTest do
  use Locations.DataCase

  import Locations.Factories

  alias Locations.Repo

  alias Locations
  alias Locations.Schema.Location

  @tag :unit
  test "will update location with geo error" do
    location = insert(:location)

    attrs = %{
      lat: nil,
      lon: nil,
      geo_selected_id: nil,
      geo_features: nil,
      geo_error: :geo_error
    }

    Locations.update_geo_location(location, attrs)

    db_location = Repo.get(Location, location.id)

    Enum.each(Map.keys(attrs), fn key ->
      expected = Map.get(attrs, key)
      actual = Map.get(db_location, key)

      assert expected == actual,
             "With key #{inspect(key)}\nExpected: #{inspect(expected)}\nActual: #{inspect(actual)}"
    end)
  end

  @tag :unit
  test "will update location with geo location" do
    location = insert(:location)

    attrs = %{
      lat: 51.7904389,
      lon: -0.894139715767561,
      geo_selected_id: 602_254_458,
      geo_features: [%{"features" => %{}}],
      geo_error: nil
    }

    {:ok, _location} = Locations.update_geo_location(location, attrs)

    db_location = Repo.get(Location, location.id)

    Enum.each(Map.keys(attrs), fn key ->
      expected = Map.get(attrs, key)
      actual = Map.get(db_location, key)

      assert expected == actual,
             "With key #{inspect(key)}\nExpected: #{inspect(expected)}\nActual: #{inspect(actual)}"
    end)
  end
end
