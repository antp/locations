defmodule Locations.Location.RemoveLocation do
  @moduledoc """
  Perform logic related removing a location to the database
  """

  import Ecto.Query, warn: false
  alias Locations.Repo

  @doc """
  Remove a location to the database
  """
  def call(location) do
    Repo.delete(location)
  end
end
