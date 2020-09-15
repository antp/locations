defmodule LocationsWeb.Live.Locations.DeleteLocationModal do
  @moduledoc """
  Displays the delete location modal
  """
  use LocationsWeb, :live_component

  alias Locations

  @impl true
  def mount(socket) do
    socket = assign(socket, remove_error: false)

    {:ok, socket}
  end

  @impl true
  def update(%{location: location}, socket) do
    socket =
      socket
      |> assign(location: location)

    {:ok, socket}
  end

  @impl true
  @doc """
  Cancel the modal
  """
  def handle_event("cancel-remove-location", _params, socket) do
    send(self(), :cancel_modal)

    {:noreply, socket}
  end

  @doc """
  Remove a location from the database
  """
  def handle_event("remove-location", _params, socket) do
    socket =
      case Locations.remove_location(socket.assigns.location) do
        {:ok, _location} ->
          send(self(), :cancel_modal)
          send(self(), :reload_locations)

          socket

        {:error, _cs} ->
          assign(socket, remove_error: true)
      end

    {:noreply, socket}
  end
end
