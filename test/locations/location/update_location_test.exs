defmodule Locations.Locations.UpdateLocationTest do
  use Locations.DataCase

  import Locations.Factories
  import Locations.AssertHelpers

  alias Locations
  alias Locations.Schema.Location

  @tag :unit
  test "will update a location" do
    location = insert(:location)
    params = string_params_for(:location)

    assert {:ok, _location} = Locations.update_location(location, params)

    db_location = Repo.get(Location, location.id)

    assert_values_set_on_schema(params, db_location)
    assert_update_timestamps(location)
  end
end
