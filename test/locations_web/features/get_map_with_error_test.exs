defmodule LocationsWeb.Features.GetMapWithErrorTest do
  use LocationsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mox
  import Locations.AssertLiveviewHelpers
  import Locations.Factories

  alias Locations.Support.NominatimData

  alias Locations.Repo

  alias Locations.Schema.Location

  @moduletag capture_log: true

  @tag :unit
  test "displays a transport error - nxdomain", %{conn: conn} do
    location = insert(:location)

    {:ok, view, _html} = live(conn, "/")

    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:error, NominatimData.get_transport_error(nil, :nxdomain)}
      end
    )

    get_map_id = "#get-map-#{location.id}"
    map_id = "#mapid-#{location.id}"

    assert_id_is_on_the_page(view, get_map_id)

    refute_id_is_on_the_page(view, map_id)

    element(view, get_map_id)
    |> render_click()

    Mox.verify!(MockHttp)

    refute_id_is_on_the_page(view, map_id)

    assert_id_is_on_the_page(view, "#geo-error-modal")

    html = render(view)

    assert html =~ "nxdomain"

    assert_location_has_error(location, :nxdomain)
  end

  @tag :unit
  test "displays a transport error - invalid url", %{conn: conn} do
    location = insert(:location)

    {:ok, view, _html} = live(conn, "/")

    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:error, NominatimData.get_transport_error("invalid URL: test", nil)}
      end
    )

    get_map_id = "#get-map-#{location.id}"
    map_id = "#mapid-#{location.id}"

    assert_id_is_on_the_page(view, get_map_id)

    refute_id_is_on_the_page(view, map_id)

    element(view, get_map_id)
    |> render_click()

    Mox.verify!(MockHttp)

    refute_id_is_on_the_page(view, map_id)

    assert_id_is_on_the_page(view, "#geo-error-modal")

    html = render(view)

    assert html =~ "invalid URL: test"

    assert_location_has_error(location, "invalid URL: test")
  end

  @tag :unit
  test "displays error - no features", %{conn: conn} do
    location = insert(:location)

    {:ok, view, _html} = live(conn, "/")

    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:ok, NominatimData.get_nominatim_no_features()}
      end
    )

    get_map_id = "#get-map-#{location.id}"
    map_id = "#mapid-#{location.id}"

    assert_id_is_on_the_page(view, get_map_id)

    refute_id_is_on_the_page(view, map_id)

    element(view, get_map_id)
    |> render_click()

    Mox.verify!(MockHttp)

    refute_id_is_on_the_page(view, map_id)

    assert_id_is_on_the_page(view, "#geo-error-modal")

    html = render(view)

    assert html =~ "Please check that the address is correct"

    assert_location_has_error(location, :no_features)
  end

  @tag :unit
  test "displays error - missing features", %{conn: conn} do
    location = insert(:location)

    {:ok, view, _html} = live(conn, "/")

    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:ok, NominatimData.get_nominatim_missing_features()}
      end
    )

    get_map_id = "#get-map-#{location.id}"
    map_id = "#mapid-#{location.id}"

    assert_id_is_on_the_page(view, get_map_id)

    refute_id_is_on_the_page(view, map_id)

    element(view, get_map_id)
    |> render_click()

    Mox.verify!(MockHttp)

    refute_id_is_on_the_page(view, map_id)

    assert_id_is_on_the_page(view, "#geo-error-modal")

    html = render(view)

    assert html =~ "We could not find the address"

    assert_location_has_error(location, :no_location)
  end

  def assert_location_has_error(location, error) do
    location = Repo.get(Location, location.id)

    assert nil == location.lat
    assert nil == location.lon
    assert nil == location.geo_features
    assert nil == location.geo_selected_id
    assert nil == location.geolocation

    assert error == location.geo_error
  end
end
