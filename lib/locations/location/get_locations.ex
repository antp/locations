defmodule Locations.Location.GetLocations do
  @moduledoc """
  Perform logic related getting all locations from the database
  """

  import Ecto.Query

  alias Locations.Repo

  alias Locations.Schema.Location

  @doc """
  Get all locations from the database
  """
  def call() do
    q =
      from(
        location in Location,
        select: location
      )

    Repo.all(q)
  end
end
