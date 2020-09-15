defmodule Locations.Location.UpdateLocation do
  @moduledoc """
  Perform logic related updating a location in the database
  """

  alias Locations.Repo

  alias Locations.Schema.Location

  @doc """
  Update a location in the database
  """
  def call(location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end
end
