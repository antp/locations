defmodule LocationsWeb.Features.ShowsFrontPageTest do
  use LocationsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Locations.AssertLiveviewHelpers

  @tag :unit
  test "will display the main page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")

    assert html =~ "<h1>Locations</h1>"
    assert html =~ "There are no Locations"

    assert assert_id_is_on_the_page(view, "#btn-add-location")
  end
end
