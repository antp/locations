defmodule Locations.Helpers.Db.EctoTuple do
  @moduledoc """
  This module provides support for converting tuples to strings
  and strings to tuples when access a database via Ecto
  """
  use Ecto.Type

  def type, do: :string

  def cast(value), do: {:ok, value}

  def load(value), do: {:ok, :erlang.binary_to_term(value, [:safe])}

  def dump(value) when not is_nil(value), do: {:ok, :erlang.term_to_binary(value)}

  def dump(_), do: :error
end
