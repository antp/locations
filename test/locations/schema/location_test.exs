defmodule Locations.Schema.LocationTest do
  use ExUnit.Case

  import Locations.Factories
  import Locations.AssertHelpers

  alias Locations.Schema.Location

  @all_keys [:addr1, :addr2, :city, :county, :postcode, :country]
  @required_keys [:addr1, :city, :postcode, :country]
  # @optional_keys [:addr2, :county]
  @all_keys_with_types [
    id: :binary_id,
    addr1: :string,
    addr2: :string,
    city: :string,
    county: :string,
    postcode: :string,
    country: :string,
    geo_error: Locations.Helpers.Db.EctoTuple,
    geo_features: {:array, :map},
    geo_selected_id: :integer,
    geolocation: Geo.PostGIS.Geometry,
    lat: :float,
    lon: :float,
    inserted_at: :naive_datetime,
    updated_at: :naive_datetime
  ]

  describe "change_location" do
    @tag :unit
    test "will be valid with correct data" do
      params = string_params_for(:location)

      cs = Locations.change_location(%Location{}, params)

      assert_valid_changeset(@all_keys, params, cs)
    end

    @tag :unit
    test "will be invalid with incorrect data types" do
      params = %{
        "addr1" => 1,
        "addr2" => 1,
        "city" => 1,
        "county" => 1,
        "postcode" => 1,
        "country" => 1
      }

      cs = Locations.change_location(%Location{}, params)

      assert_invalid_cast_changeset(@all_keys, cs)
    end

    @tag :unit
    test "will be invalid with required keys missing" do
      params = %{}

      cs = Locations.change_location(%Location{}, params)

      assert_required_changeset(@required_keys, cs)
    end
  end

  describe "schema" do
    @tag :unit
    test "required types will match" do
      assert_changeset_types(@all_keys_with_types, Location)
    end
  end
end
