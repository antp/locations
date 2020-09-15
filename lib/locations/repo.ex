defmodule Locations.Repo do
  use Ecto.Repo,
    otp_app: :locations,
    adapter: Ecto.Adapters.Postgres
end
