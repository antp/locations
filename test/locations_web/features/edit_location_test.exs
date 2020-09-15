defmodule LocationsWeb.Features.EditLocationTest do
  use LocationsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Locations.AssertLiveviewHelpers
  import Locations.Factories

  @invalid_attrs %{
    "addr1" => "",
    "city" => "",
    "postcode" => "",
    "country" => ""
  }

  setup _tags do
    # :ok = Ecto.Adapters.SQL.Sandbox.checkout(Locations.Repo)

    # unless tags[:async] do
    #   Ecto.Adapters.SQL.Sandbox.mode(Locations.Repo, {:shared, self()})
    # end

    location = insert(:location)

    {:ok, conn: Phoenix.ConnTest.build_conn(), location: location}
  end

  @tag :unit
  test "will update location modal", %{conn: conn, location: location} do
    {:ok, view, _html} = live(conn, "/")

    edit_id = "#edit-#{location.id}"
    assert_id_is_on_the_page(view, edit_id)

    element(view, edit_id)
    |> render_click()

    params = string_params_for(:location)

    view
    |> form("#locations-form",
      location: params
    )
    |> render_submit()

    html = render(view)

    assert_text_in_page(html, params)
  end

  @tag :unit
  test "will not update a location - displays errors", %{conn: conn, location: location} do
    {:ok, view, _html} = live(conn, "/")

    edit_id = "#edit-#{location.id}"
    assert_id_is_on_the_page(view, edit_id)

    element(view, edit_id)
    |> render_click()

    params = @invalid_attrs

    view
    |> form("#locations-form",
      location: params
    )
    |> render_submit()

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
end
