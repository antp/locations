defmodule LocationsWeb.Features.RemoveLocationTest do
  use LocationsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Locations.AssertLiveviewHelpers
  import Locations.Factories

  alias Locations.Repo
  alias Locations.Schema.Location

  setup _tags do
    # :ok = Ecto.Adapters.SQL.Sandbox.checkout(Locations.Repo)

    # unless tags[:async] do
    #   Ecto.Adapters.SQL.Sandbox.mode(Locations.Repo, {:shared, self()})
    # end

    location = insert(:location)

    {:ok, conn: Phoenix.ConnTest.build_conn(), location: location}
  end

  @tag :unit
  test "will remove the location", %{conn: conn, location: location} do
    {:ok, view, _html} = live(conn, "/")

    remove_id = "#remove-#{location.id}"
    assert_id_is_on_the_page(view, remove_id)

    element(view, remove_id)
    |> render_click()

    assert_id_is_on_the_page(view, "#remove-location-modal-#{location.id}")

    assert_id_is_on_the_page(view, "#remove-location")

    element(view, "#remove-location")
    |> render_click()

    assert nil == Repo.get(Location, location.id)

    refute_id_is_on_the_page(view, remove_id)
  end

  @tag :unit
  test "can cancel the modal", %{conn: conn, location: location} do
    {:ok, view, _html} = live(conn, "/")

    remove_id = "#remove-#{location.id}"
    assert_id_is_on_the_page(view, remove_id)

    element(view, remove_id)
    |> render_click()

    assert_id_is_on_the_page(view, "#remove-location-modal-#{location.id}")

    assert_id_is_on_the_page(view, "#remove-location-cancel")

    element(view, "#remove-location-cancel")
    |> render_click()

    assert nil != Repo.get(Location, location.id)

    assert_id_is_on_the_page(view, remove_id)
  end
end
