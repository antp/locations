defmodule LocationsWeb.Live.Location.LocationModal do
  @moduledoc """
  Displays the location modal that allows the user to add
  a new or update an existing location
  """
  use LocationsWeb, :live_component

  use Phoenix.HTML

  alias Locations
  alias Locations.Schema.Location

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{location: location}, socket) do
    cs = Locations.change_location(location)

    socket =
      socket
      |> assign(action: "update")
      |> assign(location: location)
      |> assign(changeset: cs)

    {:ok, socket}
  end

  def update(_params, socket) do
    cs = Locations.change_location(%Location{})

    socket =
      socket
      |> assign(action: "add")
      |> assign(changeset: cs)

    {:ok, socket}
  end

  @impl true
  def handle_event("cancel-location", _params, socket) do
    send(self(), :cancel_modal)

    {:noreply, socket}
  end

  def handle_event("validate", %{"location" => params}, socket) do
    cs =
      %Location{}
      |> Locations.change_location(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: cs)

    {:noreply, socket}
  end

  def handle_event("add", %{"location" => params}, socket) do
    socket =
      case Locations.add_location(params) do
        {:ok, _location} ->
          send(self(), :cancel_modal)
          send(self(), :reload_locations)

          socket

        {:error, %Ecto.Changeset{} = cs} ->
          assign(socket, changeset: cs, location_date_overlap: false)
      end

    {:noreply, socket}
  end

  def handle_event("update", %{"location" => params}, socket) do
    socket =
      case Locations.update_location(socket.assigns.location, params) do
        {:ok, _location} ->
          send(self(), :cancel_modal)
          send(self(), :reload_locations)

          socket

        {:error, %Ecto.Changeset{} = cs} ->
          assign(socket, changeset: cs, location_date_overlap: false)
      end

    {:noreply, socket}
  end
end
