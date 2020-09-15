defmodule Locations.GeoEncode.NominatimTest do
  @moduledoc false
  use ExUnit.Case

  alias Locations.Support.NominatimData
  alias Locations.GeoEncode.Nominatim

  @tag :unit
  test "will return error when there is no data" do
    {:error, :no_data} = Nominatim.get_location("")
  end

  @tag :unit
  test "will return error when there are no features" do
    {:error, :no_features} = Nominatim.get_location(NominatimData.no_features())
  end

  @tag :unit
  test "will return error when there are missing features" do
    {:error, :no_location} = Nominatim.get_location(NominatimData.missing_features())
  end

  @tag :unit
  test "will return ok when there are more than 1 features" do
    {:ok, features} = Nominatim.get_location(NominatimData.has_features_2())

    assert 2 == length(features)
  end
end
