defmodule LocationsWeb.Features.GetMapTest do
  use LocationsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mox
  import Locations.AssertLiveviewHelpers
  import Locations.Factories

  alias Locations.Support.NominatimData

  alias Locations.Repo

  alias Locations.Schema.Location

  @place_1_osm_id 602_254_458
  @place_2_osm_id 602_254_459

  # [-0.894139715767561,51.7904389]
  # [-0.994139715767561,61.7904389]

  describe "single feature" do
    @tag :unit
    test "will get the map", %{conn: conn} do
      location = insert(:location)

      expect(
        MockHttp,
        :get,
        fn _url, _headers, _opts ->
          {:ok, NominatimData.get_nominatim_good_response()}
        end
      )

      {:ok, view, _html} = live(conn, "/")

      get_map_id = "#get-map-#{location.id}"
      map_id = "#mapid-#{location.id}"

      assert_id_is_on_the_page(view, get_map_id)

      refute_id_is_on_the_page(view, map_id)

      element(view, get_map_id)
      |> render_click()

      assert_id_is_on_the_page(view, map_id)

      html = render(view)

      refute html =~ "Multiple locations found"

      location = Repo.get(Location, location.id)
      assert 51.7904389 == location.lat
      assert -0.894139715767561 == location.lon

      Mox.verify!(MockHttp)
    end
  end

  describe "multiple features" do
    @tag :unit
    test "will get the map show multiple features", %{conn: conn} do
      location = insert(:location)

      {:ok, view, _html} = live(conn, "/")

      select_get_map_multiple_features(view, location)

      html = render(view)

      assert html =~ "Multiple locations found"
      assert html =~ "Dinton Village Hall"
      assert html =~ "Another Hall"

      osm_id_1 = get_geo_place_id_for_location(location, @place_1_osm_id)
      assert_id_is_on_the_page(view, osm_id_1)

      osm_id_2 = get_geo_place_id_for_location(location, @place_2_osm_id)
      assert_id_is_on_the_page(view, osm_id_2)

      location = Repo.get(Location, location.id)
      assert 51.7904389 == location.lat
      assert -0.894139715767561 == location.lon
    end

    @tag :unit
    test "can switch locations", %{conn: conn} do
      location = insert(:location)

      {:ok, view, _html} = live(conn, "/")

      select_get_map_multiple_features(view, location)

      location = Repo.get(Location, location.id)
      assert 51.7904389 == location.lat
      assert -0.894139715767561 == location.lon

      osm_id_1 = get_geo_place_id_for_location(location, @place_1_osm_id)
      osm_id_2 = get_geo_place_id_for_location(location, @place_2_osm_id)

      element(view, osm_id_2)
      |> render_click()

      location = Repo.get(Location, location.id)
      assert 61.7904389 == location.lat
      assert -0.994139715767561 == location.lon

      element(view, osm_id_1)
      |> render_click()

      location = Repo.get(Location, location.id)
      assert 51.7904389 == location.lat
      assert -0.894139715767561 == location.lon
    end
  end

  defp select_get_map_multiple_features(view, location) do
    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:ok, NominatimData.get_nominatim_good_response_2()}
      end
    )

    get_map_id = "#get-map-#{location.id}"
    map_id = "#mapid-#{location.id}"

    assert_id_is_on_the_page(view, get_map_id)

    refute_id_is_on_the_page(view, map_id)

    element(view, get_map_id)
    |> render_click()

    Mox.verify!(MockHttp)

    assert_id_is_on_the_page(view, map_id)
  end

  defp get_geo_place_id_for_location(location, place_osm_id) do
    "#place-#{location.id}-#{place_osm_id}"
  end
end
