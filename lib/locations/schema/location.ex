defmodule Locations.Schema.Location do
  @moduledoc """
  This module defines the schema for a location
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Locations.Helpers.Db.EctoTuple

  @location_fields [:addr1, :city, :postcode, :country]
  @cast_fields_for_location [
    :addr1,
    :addr2,
    :city,
    :county,
    :postcode,
    :country
  ]
  @geo_fields [:lat, :lon, :geo_error, :geo_features, :geo_selected_id, :geolocation]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "locations" do
    field(:addr1, :string)
    field(:addr2, :string)
    field(:city, :string)
    field(:county, :string)
    field(:postcode, :string)
    field(:country, :string)
    field(:geo_error, EctoTuple)
    field(:geo_features, {:array, :map})
    field(:geo_selected_id, :integer)
    field(:lat, :float)
    field(:lon, :float)
    field(:geolocation, Geo.PostGIS.Geometry)

    timestamps()
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @cast_fields_for_location ++ @geo_fields)
    |> validate_required(@location_fields)
    |> validate_length(:addr1, max: 255, count: :bytes)
    |> validate_length(:addr2, max: 255, count: :bytes)
    |> validate_length(:city, max: 255, count: :bytes)
  end

  def geo_cs(location, attrs) do
    location
    |> cast(attrs, @geo_fields)
  end
end
