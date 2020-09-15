defmodule Locations.Locations.AddLocationTest do
  use Locations.DataCase

  import Locations.Factories
  import Locations.AssertHelpers

  alias Locations.Repo

  alias Locations
  alias Locations.Schema.Location

  @invalid_attrs %{
    "addr1" => "",
    "city" => "",
    "county" => "",
    "postcode" => "",
    "country" => ""
  }

  @tag :unit
  test "with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Locations.add_location(@invalid_attrs)
  end

  @tag :unit
  test "will add a location" do
    params = string_params_for(:location)

    {:ok, location} = Locations.add_location(params)

    db_location = Repo.get(Location, location.id)

    assert_values_set_on_schema(params, db_location)
    assert_insert_timestamps(db_location)
  end
end
