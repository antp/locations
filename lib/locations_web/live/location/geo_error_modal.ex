defmodule LocationsWeb.Live.Locations.GeoErrorModal do
  @moduledoc """
  Displays the GEO error modal.any()

  This is used to convey error information when GEO encoding
  """
  use LocationsWeb, :live_component

  @impl true
  def mount(socket) do
    socket = assign(socket, remove_error: false)

    {:ok, socket}
  end

  @impl true
  def update(params, socket) do
    error_reason =
      Map.get(params, :reason, nil)
      |> get_reason()

    socket =
      socket
      |> assign(reason: error_reason)

    {:ok, socket}
  end

  @impl true
  def handle_event("cancel-geo-error", _params, socket) do
    send(self(), :cancel_modal)

    {:noreply, socket}
  end

  defp get_reason(:no_features) do
    "Please check that the address is correct."
  end

  defp get_reason(:no_location) do
    "We could not find the address. Please check that the address is correct."
  end

  defp get_reason(error) do
    error
  end
end
