defmodule Locations.Locations.RemoveLocationTest do
  use Locations.DataCase

  import Locations.Factories

  alias Locations.Repo

  alias Locations
  alias Locations.Schema.Location

  @tag :unit
  test "will remove a location" do
    location = insert(:location)

    Locations.remove_location(location)

    assert nil == Repo.get(Location, location.id)
  end
end
