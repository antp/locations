defmodule Locations.Locations.GetMapForTest do
  use Locations.DataCase

  import Locations.Factories
  import Mox

  alias Locations.Support.NominatimData

  alias Locations

  @moduletag capture_log: true

  @tag :unit
  test "will return valid GEO data" do
    location = insert(:location)

    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:ok, NominatimData.get_nominatim_good_response()}
      end
    )

    {:ok, features} = Locations.get_map_for(location)

    feature = hd(features)

    assert feature["properties"]["address"]["community_centre"] == "Dinton Village Hall"
  end

  @tag :unit
  test "will return geo error" do
    location = insert(:location)

    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:error, NominatimData.get_transport_error(nil, :nxdomain)}
      end
    )

    assert {:error, :nxdomain} == Locations.get_map_for(location)
  end
end
