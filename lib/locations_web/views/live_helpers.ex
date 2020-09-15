defmodule LocationsWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  alias LocationsWeb.Live.ModalDialog

  def show_modal(socket, %ModalDialog{} = modal) do
    opts = Keyword.put_new(modal.opts, :id, :modal_content)

    m_opts = [id: :modal, component: modal.component, opts: opts]

    live_component(socket, ModalDialog, m_opts)
  end
end
