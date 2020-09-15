defmodule Locations.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Locations.Repo,
      # Start the Telemetry supervisor
      LocationsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Locations.PubSub},
      # Start the Endpoint (http/https)
      LocationsWeb.Endpoint
      # Start a worker by calling: Locations.Worker.start_link(arg)
      # {Locations.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Locations.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LocationsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
