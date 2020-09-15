defmodule LocationsWeb.Features.AddLocationTest do
  use LocationsWeb.ConnCase

  import Ecto.Query
  import Phoenix.LiveViewTest
  import Locations.AssertLiveviewHelpers
  import Locations.Factories

  alias Locations.Repo
  alias Locations.Schema.Location

  @invalid_attrs %{
    "addr1" => "",
    "city" => "",
    "postcode" => "",
    "country" => ""
  }

  @tag :unit
  test "will display the add location modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    element(view, "#btn-add-location")
    |> render_click()

    assert assert_id_is_on_the_page(view, "#add-location-modal")
  end

  @tag :unit
  test "will add a location", %{conn: conn} do
    initial_count = get_schema_count_in_db(Location)
    {:ok, view, _html} = live(conn, "/")

    element(view, "#btn-add-location")
    |> render_click()

    params = string_params_for(:location)

    view
    |> form("#locations-form",
      location: params
    )
    |> render_submit()

    added_count = get_schema_count_in_db(Location)

    assert initial_count == added_count - 1,
           "Expected a location to be added to the database"

    html = render(view)

    assert html =~ "Sorry we are unable to display the map"

    # map data is displayed
    assert_text_in_page(html, params)

    db_location = get_location(params["postcode"])

    # assert map controll buttons are there
    map_id = "#get-map-#{db_location.id}"
    assert_id_is_on_the_page(view, map_id)

    edit_id = "#edit-#{db_location.id}"
    assert_id_is_on_the_page(view, edit_id)

    remove_id = "#remove-#{db_location.id}"
    assert_id_is_on_the_page(view, remove_id)
  end

  @tag :unit
  test "will not add a location - displays errors", %{conn: conn} do
    initial_count = get_schema_count_in_db(Location)
    {:ok, view, _html} = live(conn, "/")

    element(view, "#btn-add-location")
    |> render_click()

    params = @invalid_attrs

    view
    |> form("#locations-form",
      location: params
    )
    |> render_submit()

    added_count = get_schema_count_in_db(Location)

    assert initial_count == added_count,
           "Did not expected a location to be added to the database"

    assert_form_errors(view, "locations-form", params)
  end

  @tag :unit
  test "can cancel the modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    element(view, "#btn-add-location")
    |> render_click()

    assert_id_is_on_the_page(view, "#location-cancel")

    element(view, "#location-cancel")
    |> render_click()

    refute_id_is_on_the_page(view, "#add-location-modal")
  end

  defp get_location(postcode) do
    q =
      from location in Location,
        where: location.postcode == ^postcode,
        limit: 1,
        select: location

    Repo.one(q)
  end
end
