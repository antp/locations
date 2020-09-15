defmodule LocationsWeb.Live.Location.ShowLocation do
  @moduledoc """
  Display a location
  """
  use LocationsWeb, :live_component

  alias Locations
  alias LocationsWeb.Live.ModalDialog
  alias LocationsWeb.GeoHelpers
  alias LocationsWeb.Helpers.IntegerHelpers

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{location: location}, socket) do
    geo_encoding_type = GeoHelpers.get_feature_type(location)

    socket =
      socket
      |> assign(location: location)
      |> assign(get_map_text: :get_map)
      |> assign(geo_encoding_type: geo_encoding_type)

    {:ok, socket}
  end

  @impl true
  def handle_event("edit-location", _params, socket) do
    modal = %ModalDialog{
      component: LocationsWeb.Live.Location.LocationModal,
      opts: [
        location: socket.assigns.location
      ]
    }

    send(self(), {:show_modal, modal})

    {:noreply, socket}
  end

  def handle_event("maybe-remove-location", _params, socket) do
    modal = %ModalDialog{
      component: LocationsWeb.Live.Locations.DeleteLocationModal,
      opts: [location: socket.assigns.location]
    }

    send(self(), {:show_modal, modal})

    {:noreply, socket}
  end

  def handle_event("get-map", _params, socket) do
    socket =
      case Locations.get_map_for(socket.assigns.location) do
        {:ok, geom} ->
          update_location_with_map(geom, socket)

        {:error, error} ->
          attrs = %{
            lat: nil,
            lon: nil,
            geo_selected_id: nil,
            geo_features: nil,
            geo_error: error
          }

          {:ok, location} = Locations.update_geo_location(socket.assigns.location, attrs)

          geo_encoding_type = GeoHelpers.get_feature_type(location)

          modal = %ModalDialog{
            component: LocationsWeb.Live.Locations.GeoErrorModal,
            opts: [error_dialog: true, reason: error]
          }

          send(self(), {:show_modal, modal})

          socket
          |> assign(location: location)
          |> assign(geo_encoding_type: geo_encoding_type)
      end

    {:noreply, socket}
  end

  def handle_event("map_location_selected", %{"geo_id" => geo_selected_id}, socket) do
    location = socket.assigns.location
    geo_selected_id = IntegerHelpers.to_i(geo_selected_id)

    socket =
      case GeoHelpers.get_location_for_selected(
             location.geo_features,
             geo_selected_id
           ) do
        {:ok, point, geo_selected_id} ->
          attrs = %{
            lat: point.lat,
            lon: point.lon,
            geo_selected_id: geo_selected_id
          }

          {:ok, location} = Locations.update_geo_location(socket.assigns.location, attrs)

          send(self(), :cancel_modal)

          assign(socket, location: location)

        {:error, reason} ->
          modal = %ModalDialog{
            component: GeoErrorModal,
            opts: [error_dialog: true, reason: reason]
          }

          send(self(), {:show_modal, modal})

          socket
      end

    {:noreply, socket}
  end

  # ------------

  def get_map_id(location) do
    "mapid-#{location.id}"
  end

  def get_geo_place_selected(geo_place, selected_geo_place_id) do
    if selected_geo_place_id == GeoHelpers.get_geo_place_id(geo_place) do
      "selected"
    end
  end

  def get_geo_place_id_for_location(location, place) do
    place_id = GeoHelpers.get_geo_place_id(place)

    "place-#{location.id}-#{place_id}"
  end

  def get_geo_place_id(place) do
    GeoHelpers.get_geo_place_id(place)
  end

  def get_geo_place_display_name(place) do
    GeoHelpers.get_geo_place_display_name(place)
  end

  def get_geo_place_display_type(place) do
    GeoHelpers.get_geo_place_display_type(place)
  end

  defp update_location_with_map(geom, socket) do
    case GeoHelpers.get_first_encoding_result(geom) do
      {:ok, point, geo_selected_id} ->
        attrs = %{
          lat: point.lat,
          lon: point.lon,
          geo_selected_id: geo_selected_id,
          geo_features: geom,
          geo_error: nil
        }

        {:ok, location} = Locations.update_geo_location(socket.assigns.location, attrs)

        geo_encoding_type = GeoHelpers.get_feature_type(location)

        send(self(), :cancel_modal)

        socket
        |> assign(location: location)
        |> assign(geo_encoding_type: geo_encoding_type)

      {:error, reason} ->
        modal = %ModalDialog{
          component: GeoErrorModal,
          opts: [error_dialog: true, reason: reason]
        }

        send(self(), {:show_modal, modal})

        socket
    end
  end
end
