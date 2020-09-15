defmodule LocationsWeb.PageLive do
  @moduledoc """
  Main landing page
  """
  use LocationsWeb, :live_view

  alias Locations
  alias LocationsWeb.Live.ModalDialog

  @impl true
  def mount(_params, _session, socket) do
    socket = assign_locations(socket)

    {:ok, socket}
  end

  @impl true
  def handle_event("add-Locations", _params, socket) do
    modal = %ModalDialog{
      component: LocationsWeb.Live.Location.LocationModal
    }

    send(self(), {:show_modal, modal})

    {:noreply, socket}
  end

  @impl true
  def handle_info(:cancel_modal, socket) do
    socket = assign(socket, modal: nil)

    {:noreply, socket}
  end

  def handle_info({:show_modal, modal}, socket) do
    socket = assign(socket, modal: modal)

    {:noreply, socket}
  end

  def handle_info(:reload_locations, socket) do
    socket = assign_locations(socket)

    {:noreply, socket}
  end

  defp assign_locations(socket) do
    locations = Locations.get_locations()

    assign(socket, locations: locations)
  end
end
