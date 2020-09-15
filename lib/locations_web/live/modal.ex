defmodule LocationsWeb.Live.ModalDialog do
  @moduledoc """
  Base modal dialog
  """
  use Phoenix.LiveComponent

  defstruct component: nil,
            opts: [id: :modal_content]

  def render(assigns) do
    error_dialog = Keyword.get(assigns.opts, :error_dialog, false)
    border_colour = get_border_colour(error_dialog)

    ~L"""
    <div class="fixed inset-x-0 bottom-0 px-4 pb-6 sm:inset-0 sm:p-0 sm:flex sm:items-center sm:justify-center">
      <div class="fixed inset-0 transition-opacity" phx-window-keydown="modal-cancel" phx-click="modal-cancel" phx-key="escape"
      phx-target="<%= @myself %>">
        <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
      </div>

      <div class="z-sky max-w-2xl px-4 pt-5 pb-4 overflow-hidden transition-all transform border <%= border_colour %> rounded-lg shadow-xl md:w-full bg-white" role="dialog" aria-modal="true" >
        <%= live_component @socket, @component, @opts  %>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("modal-cancel", _params, socket) do
    send(self(), :cancel_modal)

    {:noreply, socket}
  end

  defp get_border_colour(true) do
    "border-red-500"
  end

  defp get_border_colour(_) do
    "border-green-500"
  end
end
