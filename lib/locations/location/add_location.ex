defmodule Locations.Location.AddLocation do
  @moduledoc """
  Perform logic related adding a location to the database
  """

  alias Locations.Repo

  alias Locations.Schema.Location

  @doc """
  Add a location to the database
  """
  def call(%{} = attrs) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end
end
