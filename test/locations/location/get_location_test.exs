defmodule Locations.Locations.GetLocationTest do
  use Locations.DataCase

  import Locations.Factories

  alias Locations

  @tag :unit
  test "will remove a location" do
    location = insert(:location)

    db_location = Locations.get_locations()

    assert [location] == db_location
  end
end
